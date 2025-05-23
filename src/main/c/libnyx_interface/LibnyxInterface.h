/* DO NOT EDIT THIS FILE - it is machine generated */
#include <jni.h>
/* Header for class org_zlab_upfuzz_nyx_LibnyxInterface */

#ifndef _Included_org_zlab_upfuzz_nyx_LibnyxInterface
#define _Included_org_zlab_upfuzz_nyx_LibnyxInterface
#ifdef __cplusplus
extern "C" {
#endif
/*
 * Class:     org_zlab_upfuzz_nyx_LibnyxInterface
 * Method:    nyxNew
 * Signature: (Ljava/lang/String;Ljava/lang/String;IIZ)V
 */
JNIEXPORT void JNICALL Java_org_zlab_upfuzz_nyx_LibnyxInterface_nyxNew
  (JNIEnv *, jobject, jstring, jstring, jint, jint, jboolean);

/*
 * Class:     org_zlab_upfuzz_nyx_LibnyxInterface
 * Method:    nyxShutdown
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_zlab_upfuzz_nyx_LibnyxInterface_nyxShutdown
  (JNIEnv *, jobject);

/*
 * Class:     org_zlab_upfuzz_nyx_LibnyxInterface
 * Method:    nyxExec
 * Signature: ()V
 */
JNIEXPORT void JNICALL Java_org_zlab_upfuzz_nyx_LibnyxInterface_nyxExec
  (JNIEnv *, jobject);

/*
 * Class:     org_zlab_upfuzz_nyx_LibnyxInterface
 * Method:    setInput
 * Signature: (Ljava/lang/String;)V
 */
JNIEXPORT void JNICALL Java_org_zlab_upfuzz_nyx_LibnyxInterface_setInput
  (JNIEnv *, jobject, jstring);

#ifdef __cplusplus
}
#endif
#endif
