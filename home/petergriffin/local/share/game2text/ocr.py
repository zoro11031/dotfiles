import pytesseract
from pathlib import Path
import platform
from logger import log_text, log_media, get_time_string
from config import r_config, OCR_CONFIG
from util import create_directory_if_not_exists, base64_to_image, base64_to_image_path
from tools import path_to_tesseract, get_tessdata_dir
import requests
import eel
from ocr_space import ocr_space_file, OCRSPACE_API_URL_USA, OCRSPACE_API_URL_EU

HORIZONTAL_TEXT_DETECTION = 6
VERTICAL_TEXT_DETECTON = 5

def get_temp_image_path():
    return str(Path(SCRIPT_DIR,"logs", "images", "temp.png"))

def detect_and_log(engine, cropped_image,  text_orientation, session_start_time, request_time, audio_recorder):
    result = image_to_text(engine, cropped_image, text_orientation)
    if result is not None:
        log_text(session_start_time, request_time, result)
        log_media(session_start_time, request_time, audio_recorder)
        return {'id': request_time, 'result': result }
    else:
        return {'error': 'OCR Failed'}

def image_to_text(engine, base64img, text_orientation):
    if engine == "OCR Space USA" or engine == "OCR Space EU":
        api_url = OCRSPACE_API_URL_USA if engine == "OCR Space USA" else OCRSPACE_API_URL_EU
        image_path = base64_to_image_path(base64img, get_temp_image_path())
        language = r_config(OCR_CONFIG, "ocr_space_language")
        return ocr_space_file(filename=image_path, language=language, url=api_url)
    else: 
        # default to tesseract
        image = base64_to_image(base64img, get_temp_image_path())
        return tesseract_ocr(image, text_orientation)

def tesseract_ocr(image, text_orientation):
    language = r_config(OCR_CONFIG, "tesseract_language")
    psm = HORIZONTAL_TEXT_DETECTION
    if (text_orientation == 'vertical'):
        psm = VERTICAL_TEXT_DETECTON
        language += "_vert"
    custom_config = r'{} --oem {} --psm {} -c preserve_interword_spaces=1 {}'.format(get_tessdata_dir(), r_config(OCR_CONFIG, "oem"), psm, r_config(OCR_CONFIG, "extra_options").strip('"'))
    result = pytesseract.image_to_string(image, config=custom_config, lang=language)
    return result

SCRIPT_DIR = Path(__file__).parent 
tesseract_cmd, platform_name = path_to_tesseract()
pytesseract.pytesseract.tesseract_cmd = "/usr/bin/tesseract"
