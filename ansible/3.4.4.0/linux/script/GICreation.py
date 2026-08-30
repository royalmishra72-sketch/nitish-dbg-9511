# ****************************************************************************
# CREATED BY : Nitish K Mishra
# CREATED ON : 19-02-2026
#
# SCRIPT : GICreation.py
#
# TYPICAL SCRIPT LOCATION :
# /N/Nissan/NISCornerstone/1.0.0.0/app/script/GICreation.py
#
# PURPOSE :
# This script creates GI Feed from Catalog PDF.
# ****************************************************************************

import os
import re
import shutil
from pypdf import PdfReader, PdfWriter

source_pdf = r"/N/Nissan/NISCornerstone/EPO/CatalogPdf"
pdf_dir = r"/N/Nissan/NISCornerstone/EPO/Images/Attachments/GeneralInformation"

INTRO_PATTERN = re.compile(r"\bINTRODUCTION\s+IN\.", re.IGNORECASE)
TABLE_PATTERN = re.compile(r"\bTABLE OF CHASSIS NUMBERS\s+TA\.", re.IGNORECASE)
NOTE_PATTERN = re.compile(r"\bNOTE\b", re.IGNORECASE)

os.makedirs(pdf_dir, exist_ok=True)

# Copy PDFs to GeneralInformation folder
for file in os.listdir(source_pdf):
    src_path = os.path.join(source_pdf, file)
    dst_path = os.path.join(pdf_dir, file)

    if os.path.isfile(src_path):
        shutil.copy2(src_path, dst_path)


def extract_and_replace(pdf_path: str):
    filename = os.path.basename(pdf_path)
    print(f"\nProcessing: {filename}")

    name, ext = os.path.splitext(filename)
    output_name = name.replace("_US", "") + ext
    output_path = os.path.join(os.path.dirname(pdf_path), output_name)

    try:
        with open(pdf_path, "rb") as f:
            reader = PdfReader(f)
            writer = PdfWriter()

            intro_index = None
            table_index = None

            # Find INTRODUCTION and TABLE pages
            for i, page in enumerate(reader.pages):
                text = page.extract_text() or ""

                if intro_index is None and INTRO_PATTERN.search(text):
                    intro_index = i

                elif intro_index is not None and TABLE_PATTERN.search(text):
                    table_index = i
                    break

            if intro_index is not None and table_index is not None:

                # Skip NOTE page if it is immediately before TABLE page
                skip_index = None
                if table_index > intro_index:
                    prev_text = reader.pages[table_index - 1].extract_text() or ""
                    if NOTE_PATTERN.search(prev_text):
                        skip_index = table_index - 1

                # Copy pages between INTRO and TABLE
                for j in range(intro_index + 1, table_index):
                    if j == skip_index:
                        continue
                    writer.add_page(reader.pages[j])

        # Write output PDF if pages exist
        if len(writer.pages) > 0:
            with open(output_path, "wb") as out_f:
                writer.write(out_f)

            print(f"[SUCCESS] Created: {output_name}")
        else:
            print(f"[INFO] No valid pages found in {filename}. No output PDF created.")

        # Always delete copied original PDF
        os.remove(pdf_path)
        print(f"[INFO] Deleted original: {filename}")

    except Exception as e:
        print(f"[ERROR] Failed for {filename}: {e}")


# Process all copied PDFs
for file in os.listdir(pdf_dir):
    if file.lower().endswith(".pdf"):
        extract_and_replace(os.path.join(pdf_dir, file))