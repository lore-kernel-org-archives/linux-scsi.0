From: "Heinzmann, Robert" <Heinzmann@cc-dresden.de>
Subject: [PATCH] sym53c8xx module parameter passing not working (2.5.6)
Date: Fri, 1 Oct 2004 17:26:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <7AAD212492598A4A92463C3F5D34C54F194EDC@ccd3.CC.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C4A7CB.01A47B81"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mxs.tiscali.de ([62.27.59.134]:28174 "EHLO mxs.tiscali.de")
	by vger.kernel.org with ESMTP id S261375AbUJAP03 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2004 11:26:29 -0400
Received: from mail2.cc-dresden.de (port-212-202-119-51.static.qsc.de [212.202.119.51])
	by mxs.tiscali.de (Postfix) with ESMTP id 6020A26680
	for <linux-scsi@vger.kernel.org>; Fri,  1 Oct 2004 17:26:23 +0200 (CEST)
Received: from ccd3.CC.de (localhost.localdomain [127.0.0.1])
	by mail2.cc-dresden.de (8.11.6/8.11.6) with ESMTP id i91FQMK04285
	for <linux-scsi@vger.kernel.org>; Fri, 1 Oct 2004 17:26:22 +0200
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C4A7CB.01A47B81
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,=20

attached there is a patch that fixes the module parameter passing with
sym53c8xx_2. This is for SLES9 SuSE kernel, but it is so small that it
should apply for other kernels too.

Regards,=20

Robert Heinzmann

------------------------------------------------------------------------
COMPUTER CONCEPT=20
CC Computersysteme und Kommunikationstechnik GmbH=20
Robert Heinzmann
Wiener Str. 114 - 116		Email:	heinzmann@cc-dresden.de
01219 Dresden			Telefon:	+49 (0)351/8 76 92-0
					Telefax:	+49 (0)351/8 76
92-99
					Internet:
http://www.cc-dresden.de
------------------------------------------------------------------------


------_=_NextPart_001_01C4A7CB.01A47B81
Content-Type: application/octet-stream;
	name="sym53c8xx_2-module_param_handling_fix.2.6.5-7.97-default.diff"
Content-Transfer-Encoding: base64
Content-Description: sym53c8xx_2-module_param_handling_fix.2.6.5-7.97-default.diff
Content-Disposition: attachment;
	filename="sym53c8xx_2-module_param_handling_fix.2.6.5-7.97-default.diff"

LS0tIGxpbnV4L2RyaXZlcnMvc2NzaS9zeW01M2M4eHhfMi9zeW1fZ2x1ZS5jLm9yaWcJMjAwNC0w
OS0yOSAxNjo1NDoxNi4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4L2RyaXZlcnMvc2NzaS9zeW01
M2M4eHhfMi9zeW1fZ2x1ZS5jCTIwMDQtMTAtMDEgMTc6MTE6MjkuMDkzMTU0NDI0ICswMjAwCkBA
IC0xODk5LDEwICsxODk5LDExIEBACiAKIHN0YXRpYyBzdHJ1Y3Qgc3ltX2RyaXZlcl9zZXR1cAog
CXN5bV9kcml2ZXJfc2FmZV9zZXR1cCBfX2luaXRkYXRhID0gU1lNX0xJTlVYX0RSSVZFUl9TQUZF
X1NFVFVQOwotI2lmZGVmCU1PRFVMRQotY2hhciAqc3ltNTNjOHh4ID0gMDsJLyogY29tbWFuZCBs
aW5lIHBhc3NlZCBieSBpbnNtb2QgKi8KLU1PRFVMRV9QQVJNKHN5bTUzYzh4eCwgInMiKTsKLSNl
bmRpZgorLyoKKyAqICBQcm9wZXIgbW9kdWxlIHBhcmFtZXRlciBoYW5kbGluZyBpbiAyLjYKKyAq
LworY2hhciAqc3ltNTNjOHh4ID0gInN5bTUzYzh4eCAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIjsJLyogY29tbWFuZCBsaW5lIHBh
c3NlZCBieSBpbnNtb2QgKi8KK21vZHVsZV9wYXJhbShzeW01M2M4eHgsIGNoYXJwLCAwKTsKIAog
I2RlZmluZSBPUFRfTUFYX1RBRwkJMQogI2RlZmluZSBPUFRfQlVSU1RfT1JERVIJCTIKQEAgLTI0
MDQsNiArMjQwNSwxMCBAQAogCiBzdGF0aWMgaW50IF9faW5pdCBzeW0yX2luaXQodm9pZCkKIHsK
KwkjaWZkZWYgTU9EVUxFIAorCWlmIChzeW01M2M4eHgpCisJICAgICAgICBzeW01M2M4eHhfc2V0
dXAoc3ltNTNjOHh4KTsKKwkjZW5kaWYKIAlwY2lfcmVnaXN0ZXJfZHJpdmVyKCZzeW0yX2RyaXZl
cik7CiAJcmV0dXJuIDA7CiB9Ci0tLSBsaW51eC9kcml2ZXJzL3Njc2kvc3ltNTNjOHh4XzIvc3lt
X2dsdWUuaC5vcmlnCTIwMDQtMDktMjkgMTY6NTU6MDMuMDAwMDAwMDAwICswMjAwCisrKyBsaW51
eC9kcml2ZXJzL3Njc2kvc3ltNTNjOHh4XzIvc3ltX2dsdWUuaAkyMDA0LTEwLTAxIDE3OjA4OjE4
Ljk0MTA2MTkzNiArMDIwMApAQCAtNjEsNiArNjEsMTUgQEAKICNpbmNsdWRlIDxsaW51eC90aW1l
ci5oPgogI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CiAKKy8qIFByb3BlciBtb2R1bGUgcGFyYW1l
dGVyIHBhc3NpbmcgaW4gMi42ICovCisjaWZuZGVmIExJTlVYX1ZFUlNJT05fQ09ERQorI2luY2x1
ZGUgPGxpbnV4L3ZlcnNpb24uaD4KKyNlbmRpZiAvKiBMSU5VWF9WRVJTSU9OX0NPREUgKi8KKwor
I2lmIGRlZmluZWQoTU9EVUxFKSAmJiBMSU5VWF9WRVJTSU9OX0NPREUgPj0gS0VSTkVMX1ZFUlNJ
T04oMiw2LDApCisjaW5jbHVkZSA8bGludXgvbW9kdWxlcGFyYW0uaD4KKyNlbmRpZiAKKwogI2lu
Y2x1ZGUgPGFzbS9pby5oPgogI2lmZGVmIF9fc3BhcmNfXwogIyAgaW5jbHVkZSA8YXNtL2lycS5o
Pgo=

------_=_NextPart_001_01C4A7CB.01A47B81
Content-Type: text/plain;
	name="sym53c8xx_2-module_param_handling_fix.2.6.5-7.97-default.Readme.txt"
Content-Transfer-Encoding: base64
Content-Description: sym53c8xx_2-module_param_handling_fix.2.6.5-7.97-default.Readme.txt
Content-Disposition: attachment;
	filename="sym53c8xx_2-module_param_handling_fix.2.6.5-7.97-default.Readme.txt"

VGhlIDIuNiB2ZXJzaW9uIG9mIHN5bTUzYzh4eF8yIGRpZCBub3QgcmVhZCB0aGUgbW9kdWxlIGNv
bW1hbmQgbGluZSBwYXJhbWV0ZXIgcHJvcGVybHkuIA0KVGhpcyB3YXMgZHVlIHRvIGEgbWlzc2lu
ZyBjYWxsIHRvIHN5bTUzYzh4eF9zZXR1cCgpLg0KDQpUaGlzIGZpeCBpbmNsdWRlczogDQotIGFk
ZGVkIG1pc3NpbmcgY2FsbCB0byBzeW01M2M4eHhfc2V0dXAoKQ0KLSBpbnRyb2R1Y2VzIHByb3Bl
ciAyLjYgbW9kdWxlX3BhcmFtKCkgaGFuZGxpbmcNCiAgKGNoYW5nZWQgTU9EVUxFX1BBUk0gdG8g
bW9kdWxlX3BhcmFtKCkpOw0KDQpSb2JlcnQgSGVpbnptYW5uIChIZWluem1hbm5AY2MtZHJlc2Rl
bi5kZSkNCg0KDQo=

------_=_NextPart_001_01C4A7CB.01A47B81--
