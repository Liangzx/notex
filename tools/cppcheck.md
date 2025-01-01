# cmd

```shell
cppcheck    --enable=style \
            --enable=warning \
            --enable=performance \
            --enable=portability \
            --enable=information \
            --enable=missingInclude \
            --enable=unusedFunction \
            --suppress=missingIncludeSystem \
            --std=c++11 \
    sangforscp/job/backup_executor.cpp
```
