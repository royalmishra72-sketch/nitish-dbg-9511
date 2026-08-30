#!/usr/bin/python
import argparse
import logging
import os
import sys
from sbs.imageconversion.imageprocessor import ImageProcessor


class IPP_Nissan(object):
    stat_rdyimg = None
    threads = 8
    inputpath = None
    logger = None
    verbose = False
    outputpath = None
    statsfile = None
    stylesheetpath = None
    normalizationstylesheetname = 'normalizeNissan.xsl'
    normalizationstylesheetpath = None
    calloutextractionstylesheetname = 'extractNissanCallouts.xsl'
    calloutextractionstylesheetpath = None
    thumbnailwidth = 245
    thumbnailheight = 215
    exceptioncount = 0

    def __init__(self, inputpath, outputpath, stylesheetpath, logger=None, threadCount=8):
        outputpathtemp = None
        if logger is not None:
            self.logger = logger
        else:
            self.logger = logging.getLogger()
        self.threads = threadCount
        self.inputpath = os.path.abspath(inputpath)
        if self.inputpath is None:
            self.logger.error('Input directory not given')
            raise EOFError
        if not os.path.exists(self.inputpath):
            self.logger.error('Input directory {} does not exist'.format(self.inputpath))
            raise IOError
        if not os.path.isdir(self.inputpath):
            self.logger.error('{} is not a directory'.format(self.inputpath))
            raise NotADirectoryError
        if outputpath is None:
            outputpathtemp = self.inputpath
        else:
            outputpathtemp = outputpath
        if not os.path.isdir(outputpathtemp):
            self.logger.error('{} is not a directory'.format(outputpathtemp))
            raise NotADirectoryError
        if not os.access(outputpathtemp, os.W_OK):
            self.logger.error('write not permitted in {}'.format(outputpathtemp))
            raise PermissionError
        else:
            self.outputpath = outputpathtemp
        if stylesheetpath is None:
            # If no stylesheet path was provided, look for the stylesheets in the same directory as this script
            self.stylesheetpath = os.path.dirname(os.path.realpath(__file__))
        else:
            if os.path.isdir(stylesheetpath):
                self.stylesheetpath = stylesheetpath
            else:
                self.logger.error('Stylesheet path {} is not a directory'.format(stylesheetpath))
                raise NotADirectoryError
        self.normalizationstylesheetpath = os.path.join(self.stylesheetpath, self.normalizationstylesheetname)
        self.calloutextractionstylesheetpath = os.path.join(self.stylesheetpath, self.calloutextractionstylesheetname)
        stylesheetsfound = True
        if not os.path.exists(self.normalizationstylesheetpath):
            self.logger.error('Normalization stylesheet {} was not found in directory {}'.format(
                self.normalizationstylesheetname, self.stylesheetpath))
            stylesheetsfound = False
        else:
            self.logger.info('Found normalization stylesheet {} in directory {}'.format(
                self.normalizationstylesheetname, self.stylesheetpath))
        if not os.path.exists(self.calloutextractionstylesheetpath):
            self.logger.error('Callout extraction stylesheet {} was not found in directory {}'.format(
                self.calloutextractionstylesheetname, self.stylesheetpath))
            stylesheetsfound = False
        else:
            self.logger.info('Found callout extraction stylesheet {} in directory {}'.format(
                self.calloutextractionstylesheetname, self.stylesheetpath))
        if stylesheetsfound is False:
            raise FileNotFoundError

    def setVerbose(self):
        self.verbose = True

    def setStatsFile(self, statsfile):
        self.statsfile = statsfile

    def setThumbnailWidth(self, width):
        self.thumbnailwidth = width

    def setThumbnailHeight(self, height):
        self.thumbnailheight = height

    def NOT_RUN(self):
        return 'Not run'

    def RUN_ERRORS(self):
        return 'Run, error(s)'

    def RUN_FAILED(self):
        return 'Run, failed'

    def RUN_PASSED(self):
        return 'Run, passed'

    def MakeReadyImages(self):
        ip = None
        try:
            ip = ImageProcessor(self.outputpath, threadCount=self.threads)
            ip.verbose = self.verbose
            ip.format = 'png'  # Output format PNG
            # Only process SVG and SVGZ files in case other files exist in input directory
            ip.matchPattern = r'\.[Ss][Vv][Gg][Zz]?$'
            ip.depthGray = 8
            ip.depthLoColor = 8
            ip.depthHiColor = 8
            ip.countGray = 256
            ip.countLoColor = 256
            ip.countHiColor = 256
            ip.forceReduce = True
            ip.dither = 'None'
            ip.exportDPI = 132
            ip.gsRasterize = True
            ip.thumbnail = True
            ip.thumbnailWidth = self.thumbnailwidth
            ip.thumbnailHeight = self.thumbnailheight
            ip.optimize = True
            ip.stylesheet = self.normalizationstylesheetpath
            ip.imageDataStylesheet = self.calloutextractionstylesheetpath
            if self.statsfile is not None:
                ip.statsFile = self.statsfile
            ip.initialize()  # Initialize the ImageTransformer
            self.logger.debug('creating PNG files in {}'.format(self.outputpath))
            try:
                ip.processDirectory(self.inputpath)
            except Exception as e:
                self.exceptioncount += 1
            status_values = ip.file_status()
            self.logger.info("Conversion results:")
            for imgfile in sorted(status_values.keys()):
                if 0 == status_values[imgfile]:
                    self.logger.info('{}: Converted successfully\n    stdout: {}'.format(os.path.basename(imgfile),
                        ip.file_stdout(imgfile)))
                else:
                    self.logger.info('{}: Failed\n    stdout: {}\n    stderr: {}'.format(os.path.basename(imgfile),
                        ip.file_stdout(imgfile), ip.file_stderr(imgfile)))
            self.logger.info('{:d} exception(s) were raised by ImageProcessor'.format(self.exceptioncount))
            if 0 == ip.exit_code():
                self.stat_rdyimg = self.RUN_PASSED()
            else:
                self.stat_rdyimg = self.RUN_ERRORS()
        except Exception as e:
            if ip is None or ip.countSucceeded() < 1:
                self.stat_rdyimg = self.RUN_FAILED()
                raise RuntimeError('create ready image failed: {}'.format(str(e)))
            else:
                self.stat_rdyimg = self.RUN_ERRORS()
        finally:
            if ip is not None:
                if 0 < ip.countFailed():
                    self.logger.error('create ready images failed on {:d} of {:d} files'.format(ip.countFailed(),
                        ip.countAttempted()))
                del ip

    def process(self):
        self.stat_rdyimg = self.NOT_RUN()
        try:
            self.MakeReadyImages()
        except Exception as e:
            self.logger.error(e)

    def status(self):
        if self.stat_rdyimg == self.RUN_PASSED():
            return 0, 'PASSED {}'.format(self.inputpath)
        elif self.stat_rdyimg == self.RUN_ERRORS():
            return 0, 'PASSED with errors, {}: Ready images: {}'.format(self.inputpath, self.stat_rdyimg)
        else:
            return 1, 'FAILED, {}; Ready images: {}'.format(self.inputpath, self.stat_rdyimg)


def main():
    helpstring = 'Nissan_ipp_svg.py: Process SVG(Z) files for Nissan.'
    parser = argparse.ArgumentParser(description=helpstring)
    parser.add_argument('-v', '--verbose', dest='verbose', action='store_true', help='enable verbose output')
    parser.add_argument('-d', '--debug', dest='debug', action='store_true', help='enable debugging messages')
    parser.add_argument('-l', '--log', dest='log', help='log file (default to stdout)')
    parser.add_argument('-t', '--threads', dest='threads', type=int, default=8, metavar='<COUNT>',
                        help='thread count (default 8)')
    parser.add_argument('-s', '--statsfile', dest='statsfile', metavar='<PATH>',
                        help='ImageProcessor stats file, (default to log file)')
    parser.add_argument('--stylesheetpath', dest='stylesheetpath', metavar='<PATH>',
                        help='Path to directory containing XSLT stylesheets (defaults to the directory that ' +
                             'contains this script)')
    parser.add_argument('--thumbnailwidth', dest='thumbnailwidth', metavar='<WIDTH>',
                        help='Thumbnail width (default 245)')
    parser.add_argument('--thumbnailheight', dest='thumbnailheight', metavar='<HEIGHT>',
                        help='Thumbnail height (default 215)')
    parser.add_argument('-o', '--output', dest='output', metavar='<PATH>',
                        help='output directory (defaults to input directory)')
    parser.add_argument('input', help='input directory')
    args = parser.parse_args()
    # set up logging
    log_level = logging.WARNING
    log_format = '%(levelname)s: %(asctime)s %(message)s'
    log_datefmt = '%Y-%m-%d %H:%M:%S'
    if args.verbose:
        log_level = logging.INFO
    if args.debug:
        log_level = logging.DEBUG
    if args.log is not None:
        logging.basicConfig(filename=args.log, format=log_format, datefmt=log_datefmt, level=log_level)
    else:
        logging.basicConfig(stream=sys.stdout, format=log_format, datefmt=log_datefmt, level=log_level)
    log_logger = logging.getLogger()
    log_logger.setLevel(log_level)

    try:
        ipp = IPP_Nissan(args.input, args.output, args.stylesheetpath, logger=log_logger, threadCount=args.threads)
    except Exception as e:
        log_logger.error(repr(sys.exc_info()[1]))
        sys.exit(1)
    if args.verbose:
        ipp.setVerbose()
    if args.statsfile is not None:
        ipp.setStatsFile(args.statsfile)
    if args.thumbnailwidth is not None:
        ipp.setThumbnailWidth(args.thumbnailwidth)
    if args.thumbnailheight is not None:
        ipp.setThumbnailHeight(args.thumbnailheight)
    try:
        ipp.process()
    except Exception as e:
        log_logger.error(repr(sys.exc_info()[1]))
        sys.exit(1)
    exit_code, message = ipp.status()
    if exit_code != 0:
        log_logger.error('exit {:d}: {}'.format(exit_code, message))
    else:
        log_logger.setLevel(logging.INFO)  # Ensure that this message is logged
        log_logger.info(message)

    sys.exit(exit_code)


if __name__ == '__main__':
    main()
