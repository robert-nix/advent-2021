#include <jni.h>
#include <string>

uint16_t day1(uint16_t part, const char *in) {
  uint16_t ns[4];
  uint16_t wp = 0;
  uint16_t r = 0;
  uint16_t w = 1;
  if (part == 2)
    w = 3;
  for (uint i = 0; i < 4; i++)
    ns[i] = 0;
  while (1) {
    char c = *in++;
    if (c == 0 || c == '\n') {
      if (ns[(wp - w) & w] && ns[wp]) {
        uint16_t a = 0, b = 0;
        for (uint16_t j = 0; j < w; j++) {
          a += ns[(wp - w + j) & w];
          b += ns[(wp - w + j + 1) & w];
        }
        if (b > a)
          r++;
      }
      if (c == 0)
        break;
      wp = (wp + 1) & w;
      ns[wp] = 0;
    } else {
      ns[wp] = ns[wp] * 10 + c - '0';
    }
  }
  return r;
}

static char buf[17];

const char *process_input(uint16_t day, uint16_t part, const char *in) {
  uint16_t r;
  switch (day) {
  case 1:
    r = day1(part, in);
    break;
  default:
    return "";
  }
  char *c = buf + 16;
  do {
    *--c = '0' + (r % 10);
    r /= 10;
  } while (r != 0);
  return c;
}

extern "C" JNIEXPORT jstring JNICALL
Java_cc_furl_advent_MainActivity_processInput(JNIEnv *env, jobject /* this */,
                                              jint day, jint part,
                                              jstring input) {
  const char *inputStr = env->GetStringUTFChars(input, nullptr);
  if (inputStr == nullptr) {
    return nullptr;
  }
  jstring result =
      env->NewStringUTF(process_input((uint16_t)day, (uint16_t)part, inputStr));
  env->ReleaseStringUTFChars(input, inputStr);
  return result;
}
