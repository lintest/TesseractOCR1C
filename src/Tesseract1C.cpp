#include "stdafx.h"
#include "Tesseract1C.h"
#include "Tesseract1C.h"

std::vector<std::u16string> TesseractControl::names = {
	AddComponent(u"TesseractOCR", []() { return new TesseractControl; }),
	AddComponent(u"TesseractOCR1C", []() { return new TesseractControl; }),
};

TesseractControl::TesseractControl()
{
	AddFunction(u"Init", u"Инициализировать", [&](VH path, VH lang) { this->result = this->Init(path, lang); });

	AddFunction(u"Recognize", u"Распознать"
		, [&](VH image, VH r, VH g, VH b) { Recognize(image, r, g, b); }
		, { {1, 0.0}, {2, 0.0}, {3, 0.0}, }
	);

	AddFunction(u"Discolor", u"Обесцветить"
		, [&](VH image, VH r, VH g, VH b) { Grayscale(image, r, g, b); }
		, { {1, 0.0}, {2, 0.0}, {3, 0.0}, }
	);

	AddProcedure(u"Exit", u"ЗавершитьРаботуСистемы", [&](VH status) { ExitProcess((UINT)(int)status); }, { {0, (int64_t)0 } });
}

TesseractControl::~TesseractControl()
{
}

bool TesseractControl::Init(const std::string& path, const std::string& lang)
{
	ok = api.Init(path.c_str(), lang.c_str(), tesseract::OEM_DEFAULT) == 0;
	if (ok) api.SetPageSegMode(tesseract::PSM_AUTO);
	return ok;
}

struct PixDeleter {
	void operator()(PIX* pix) { if (pix) pixDestroy(&pix); }
};

using namespace tesseract;

JSON rect(std::unique_ptr<ResultIterator>& it, PageIteratorLevel level)
{
	int left, top, right, bottom;
	it->BoundingBox(level, &left, &top, &right, &bottom);
	return {
		{"Left", left},
		{"Top", top},
		{"Width", right - left},
		{"Heigth", bottom - top},
	};
}

void TesseractControl::Grayscale(VH& img, double r, double g, double b)
{
	std::unique_ptr<PIX, PixDeleter> pix{
		pixReadMem((l_uint8*)img.data(), img.size())
	};
	pix.reset(
		pixConvertRGBToGray(pix.get(), (l_float32)r, (l_float32)g, (l_float32)b)
	);
	l_uint8* data = nullptr;
	size_t size = 0;
	if (pixWriteMem(&data, &size, pix.get(), IFF_PNG) == 0) {
		result.AllocMemory(size);
		memcpy(result.data(), data, size);
		delete data;
	}
}

void TesseractControl::Recognize(VH& img, double r, double g, double b)
{
	if (!ok) return;
	std::unique_ptr<PIX, PixDeleter> pix{
		pixReadMem((l_uint8*)img.data(), img.size())
	};
	pix.reset(
		pixConvertRGBToGray(pix.get(), (l_float32)r, (l_float32)g, (l_float32)b)
	);
	api.SetImage(pix.get());
	api.Recognize(nullptr);
	std::unique_ptr<ResultIterator> it(api.GetIterator());
	JSON json;
	while (!it->Empty(RIL_BLOCK)) {
		JSON block;
		while (!it->Empty(RIL_PARA)) {
			JSON para;
			while (!it->Empty(RIL_TEXTLINE)) {
				JSON line;
				while (!it->Empty(RIL_WORD)) {
					JSON word = rect(it, RIL_WORD);
					word["Text"] = it->GetUTF8Text(RIL_WORD);
					word["Conf"] = (int)it->Confidence(RIL_WORD);
					line.push_back(word);
					if (it->IsAtFinalElement(RIL_TEXTLINE, RIL_WORD)) break;
					it->Next(RIL_WORD);
				}
				para.push_back(line);
				if (it->IsAtFinalElement(RIL_PARA, RIL_TEXTLINE)) break;
				it->Next(RIL_TEXTLINE);
			}
			block.push_back(para);
			if (it->IsAtFinalElement(RIL_BLOCK, RIL_PARA)) break;
			it->Next(RIL_PARA);
		}
		json.push_back(block);
		it->Next(RIL_BLOCK);
	}
	result = json.dump();
}
