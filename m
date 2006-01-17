From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 2/8] fusion - mptsas, increase discovery timout to 300 seconds
Date: Mon, 16 Jan 2006 18:53:11 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC7E@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61B08.C5AD3FB3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7643 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751327AbWAQBxM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 20:53:12 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0H1m1NI021591
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:48:01 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0H1rCOs007111
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:53:12 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61B08.C5AD3FB3
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Increase the port enable timeout only for SAS from 30 to 300 seconds.
A customer request for the handling large topologies.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C61B08.C5AD3FB3
Content-Type: application/octet-stream;
	name="fusion-2-port-enable.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-2-port-enable.patch
Content-Disposition: attachment;
	filename="fusion-2-port-enable.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0YmFzZS5jIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMKLS0tIGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRi
YXNlLmMJMjAwNi0wMS0xNiAxNzo1NzozMS4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMJMjAwNi0wMS0xNiAxODoxMzo0MC4wMDAwMDAwMDAgLTA3
MDAKQEAgLTI3NzAsMTMgKzI3NzAsMTYgQEAKIAogCS8qIFJBSUQgRlcgbWF5IHRha2UgYSBsb25n
IHRpbWUgdG8gZW5hYmxlCiAJICovCi0JaWYgKCAoaW9jLT5mYWN0cy5Qcm9kdWN0SUQgJiBNUElf
RldfSEVBREVSX1BJRF9QUk9EX01BU0spCi0JCQk+IE1QSV9GV19IRUFERVJfUElEX1BST0RfVEFS
R0VUX1NDU0kgKSB7Ci0JCXJjID0gbXB0X2hhbmRzaGFrZV9yZXFfcmVwbHlfd2FpdChpb2MsIHJl
cV9zeiwgKHUzMiopJnBvcnRfZW5hYmxlLAotCQkJCXJlcGx5X3N6LCAodTE2KikmcmVwbHlfYnVm
LCAzMDAgLypzZWNvbmRzKi8sIHNsZWVwRmxhZyk7CisJaWYgKCgoaW9jLT5mYWN0cy5Qcm9kdWN0
SUQgJiBNUElfRldfSEVBREVSX1BJRF9QUk9EX01BU0spCisJICAgID4gTVBJX0ZXX0hFQURFUl9Q
SURfUFJPRF9UQVJHRVRfU0NTSSkgfHwKKwkgICAgKGlvYy0+YnVzX3R5cGUgPT0gU0FTKSkgewor
CQlyYyA9IG1wdF9oYW5kc2hha2VfcmVxX3JlcGx5X3dhaXQoaW9jLCByZXFfc3osCisJCSh1MzIq
KSZwb3J0X2VuYWJsZSwgcmVwbHlfc3osICh1MTYqKSZyZXBseV9idWYsCisJCTMwMCAvKnNlY29u
ZHMqLywgc2xlZXBGbGFnKTsKIAl9IGVsc2UgewotCQlyYyA9IG1wdF9oYW5kc2hha2VfcmVxX3Jl
cGx5X3dhaXQoaW9jLCByZXFfc3osICh1MzIqKSZwb3J0X2VuYWJsZSwKLQkJCQlyZXBseV9zeiwg
KHUxNiopJnJlcGx5X2J1ZiwgMzAgLypzZWNvbmRzKi8sIHNsZWVwRmxhZyk7CisJCXJjID0gbXB0
X2hhbmRzaGFrZV9yZXFfcmVwbHlfd2FpdChpb2MsIHJlcV9zeiwKKwkJKHUzMiopJnBvcnRfZW5h
YmxlLCByZXBseV9zeiwgKHUxNiopJnJlcGx5X2J1ZiwKKwkJMzAgLypzZWNvbmRzKi8sIHNsZWVw
RmxhZyk7CiAJfQogCXJldHVybiByYzsKIH0K

------_=_NextPart_001_01C61B08.C5AD3FB3--
