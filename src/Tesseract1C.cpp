#include "stdafx.h"
#include "Tesseract1C.h"
#include "Tesseract1C.h"

std::vector<std::u16string> TesseractControl::names = {
	AddComponent(u"Tesseract1C", []() { return new TesseractControl; }),
};

TesseractControl::TesseractControl()
{
	AddProcedure(u"Init", u"Инициализировать", [&](VH path, VH lang) { this->Init(path, lang); });
	AddFunction(u"GetHOCR", u"GetHOCR", [&](VH var) { this->result = GetHOCRText(var); });
}

TesseractControl::~TesseractControl()
{
}

void TesseractControl::Init(const std::string& path, const std::string& lang)
{
	api.Init(path.c_str(), lang.c_str());
}

std::string TesseractControl::GetHOCRText(VH& img)
{
	std::unique_ptr<PIX> pix{ pixReadMem((l_uint8*)img.data(), img.size()) };
	api.SetImage(pix.get());
	std::unique_ptr<char[]> text(api.GetHOCRText(1));
	return std::string(text.get());
}
