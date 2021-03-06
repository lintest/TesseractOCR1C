# External modules converter for 1C

Данный инструмент предназначен для быстрой у удобной конвертации внешних обработок (epf файлов) и внешних отчетов (erf файлов) в формат xml и обратно.

Для работы инструмента вам понадобится установить [OneScript](http://oscript.io) версии 1.0.20 или выше.

## Пример использования
1. Допустим у вас есть каталог/каталоги внешних отчетов и обработок.
2. Чтобы сконвертировать все файлы из каталога и его подкаталогов в xml формат нужно выполнить команду
```
oscript Decompile.os МойКаталог
```

3. Чтобы сконвертировать все файлы из каталога из xml формата обратно в бинарый надо выполнить команду
```
oscript Compile.os МойКаталог
```

## Для работы скриптов необходимо
1. Установить [OneScript](http://oscript.io) версии 1.0.20 или выше.
2. Также, чтобы работала сборка epf/erf надо установить платформу [1С:Предприятие 8.3.10](https://releases.1c.ru).


## Особенности использования
1. При первой распаковке файла будет создан служебный файл "filename". Он нужен, т.к. имя xml файла и имя epf/erf файла в общем случае могут различаться.
2. Файл filename лучше не добавлять в .gitignore, если вы планируете хранить исходники в git.
3. Также будет создан служебный файл "fileversion". Он нужен для того, чтобы делать конвертацию в xml и обратно только тех файлов, которые реально изменились.
4. Файл fileversion надо добавить в .gitignore.
5. Также пример использования данного инструмента можно увидеть в проекте Vanessa-Automation версии [1.2.001](https://github.com/Pr-Mex/vanessa-automation) и выше.
