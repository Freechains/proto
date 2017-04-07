CEU_DIR    = $(error set absolute path to "<ceu>" repository)
CEU_UV_DIR = $(error set absolute path to "<ceu-libuv>" repository)

all:
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_UV_DIR)/include -Isrc/" \
	          --pre-input=$(CEU_SRC)                                           \
	    --ceu --ceu-features-lua=true --ceu-features-thread=true               \
	          --ceu-err-unused=pass --ceu-err-uninitialized=pass               \
	    --env --env-types=$(CEU_DIR)/env/types.h                               \
	          --env-threads=$(CEU_UV_DIR)/env/threads.h                        \
	          --env-main=$(CEU_DIR)/env/main.c                                 \
	    --cc --cc-args="-lm -llua5.3 -luv -lsodium -g"                         \
	         --cc-output=freechains

ceu:
	ceu --pre --pre-args="-I$(CEU_DIR)/include -I$(CEU_UV_DIR)/include -Isrc/" \
	          --pre-input=$(CEU_SRC)  --pre-output=/tmp/x.ceu \
	    --ceu --ceu-input=/tmp/x.ceu --ceu-features-lua=true --ceu-features-thread=true               \
	          --ceu-err-unused=pass --ceu-err-uninitialized=pass               \
	          --ceu-line-directives=false \
	    --env --env-types=$(CEU_DIR)/env/types.h                               \
	          --env-threads=$(CEU_UV_DIR)/env/threads.h                        \
	          --env-main=$(CEU_DIR)/env/main.c  --env-output=/tmp/x.c                                \
	    --cc --cc-args="-lm -llua5.3 -luv -lsodium -g"							   \
	         --cc-output=freechains

c:
	ceu --cc --cc-input=/tmp/x.c --cc-args="-lm -llua5.3 -luv -lsodium -g"							   \
	         --cc-output=freechains

tests:
	for i in tst/*.ceu; do                               \
		echo;                                            \
		echo "#####################################";    \
		echo File: "$$i";                                \
		echo "#####################################";    \
		make CEU_SRC=$$i && ./freechains || exit 1;      \
		if [ "$$i" = "tst/tst-32.ceu" ]; then break; fi; \
	done

# 01->32
#real	8m57.250s
#user	5m25.088s
#sys	0m10.500s


# 32
# 20*20=400 messages, 400*20=8000 minimum receives
# BLOCKS = 45634, 44450, 42336, 42175 (5.3x)
#real	4m1.622s
#user	2m23.344s
#sys	0m4.324s

# 35
# 7*7=49 messages, 49*7=343 minimum receives
# BLOCKS = 3081, 4012 (8.9x)
#real	0m39.997s
#user	0m15.252s
#sys	0m0.588s
