#pragma once
#include "stdafx.h"
#include "AddInNative.h"
#include <baseapi.h>
#include <allheaders.h>

class TesseractControl : public AddInNative
{
private:
    bool ok = false;
    tesseract::TessBaseAPI api;
private:
    static std::vector<std::u16string> names;
    TesseractControl();
    virtual ~TesseractControl();
    bool Init(const std::string& path, const std::string& lang);
    void Grayscale(VH& data, double r, double g, double b);
    void Recognize(VH& data, double r, double g, double b);
};
