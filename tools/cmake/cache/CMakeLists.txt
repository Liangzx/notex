cmake_minimum_required(VERSION 3.18)

# 设置工程名称
set(PROJECT_NAME KAIZEN)

# 设置工程版本号
set(PROJECT_VERSION "1.0.0.10" CACHE STRING "默认版本号")

# 工程定义
project(${PROJECT_NAME}
    LANGUAGES CXX C
    VERSION ${PROJECT_VERSION}
)

# 打印开始日志
message(STATUS "\n########## BEGIN_TEST_CACHE_VARIABLE")

### 定义缓存变量

# 定义一个STRIING类型缓存变量(不加FORCE选项)
set(MY_GLOBAL_VAR_STRING_NOFORCE "abcdef" CACHE STRING "定义一个STRING缓存变量")
message("MY_GLOBAL_VAR_STRING_NOFORCE: ${MY_GLOBAL_VAR_STRING_NOFORCE}")

# 定义一个STRIING类型缓存变量(加FORCE选项)
set(MY_GLOBAL_VAR_STRING "abc" CACHE STRING "定义一个STRING缓存变量" FORCE)
message("MY_GLOBAL_VAR_STRING: ${MY_GLOBAL_VAR_STRING}")

# 定义一个INTERNAL类型缓存变量
set(MY_GLOBAL_VAR_INTERNAL "aaabbb" CACHE INTERNAL "定义一个INTERNAL类型的缓存变量")
message("MY_GLOBAL_VAR_INTERNAL: ${MY_GLOBAL_VAR_INTERNAL}")

# 定义一个BOOL类型缓存变量
set(MY_GLOBAL_VAR_BOOL OFF CACHE BOOL "定义一个BOOL类型的缓存变量")
message("MY_GLOBAL_VAR_BOOL: ${MY_GLOBAL_VAR_BOOL}")

# 定义一个FILEPATH类型缓存变量
set(MY_GLOBAL_VAR_FILEPATH "F:/learn_cmake/CMakeLists.txt" CACHE FILEPATH "定义一个FILEPATH类型的缓存变量")
message("MY_GLOBAL_VAR_FILEPATH: ${MY_GLOBAL_VAR_FILEPATH}")

# 定义一个PATH类型缓存变量
set(MY_GLOBAL_VAR_PATH "F:/learn_cmake" CACHE PATH "定义一个PATH类型的缓存变量")
message("MY_GLOBAL_VAR_PATH: ${MY_GLOBAL_VAR_PATH}")

# 定义一个缓存变量3个值(验证值列表场景)
set(MY_GLOBAL_VAR_THRESS "aaa" "bbb" "ccc" CACHE STRING "定义一个缓存变量（3个值）")
message("MY_GLOBAL_VAR_THRESS: ${MY_GLOBAL_VAR_THRESS}")

### 修改缓存变量

# 修改定义时不加FORCE的缓存变量(不加FORCE选项方式修改)
set(MY_GLOBAL_VAR_STRING_NOFORCE "modify_abcdef_without_force" CACHE STRING "修改一个STRING缓存变量")
message("MY_GLOBAL_VAR_STRING_NOFORCE: ${MY_GLOBAL_VAR_STRING_NOFORCE}")

# 修改定义时不加FORCE的缓存变量(加FORCE选项方式修改)
set(MY_GLOBAL_VAR_STRING_NOFORCE "modify_abcdef_with_force" CACHE STRING "修改一个STRING缓存变量" FORCE)
message("MY_GLOBAL_VAR_STRING_NOFORCE: ${MY_GLOBAL_VAR_STRING_NOFORCE}")

# 修改定义时加FORCE的STRING类型缓存变量(不加FORCE选项方式修改)
set(MY_GLOBAL_VAR_STRING "modify_abc_without_force" CACHE STRING "修改STRING缓存变量")
message("MY_GLOBAL_VAR_STRING: ${MY_GLOBAL_VAR_STRING}")

# 修改定义时加FORCE的STRING类型缓存变量(加FORCE选项方式修改)
set(MY_GLOBAL_VAR_STRING "modify_abc_with_force" CACHE STRING "修改STRING缓存变量" FORCE)
message("MY_GLOBAL_VAR_STRING: ${MY_GLOBAL_VAR_STRING}")

# 打印结束日志
message(STATUS "\n########## END_TEST_CACHE_VARIABLE\n")

# https://www.cnblogs.com/Braveliu/p/15614013.html
