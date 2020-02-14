dir

xcopy /S /I /E . %LIBRARY_PREFIX%
del %LIBRARY_PREFIX%\*.bat %LIBRARY_PREFIX%\*.yaml
