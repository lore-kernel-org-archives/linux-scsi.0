From: "Seokmann Ju" <seokmann.ju@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: add support for NPIV
Date: Thu, 5 Jul 2007 13:17:01 -0700
Message-ID: <A6970E9A290F3F4682E1EAD0EA14F32B01293112@AVEXCH2.qlogic.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7BF41.8CB69EF4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:8687 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXGEUSc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 16:18:32 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linux Driver <Linux-Driver@qlogic.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7BF41.8CB69EF4
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Following patch bump up the driver version reflecting NPIV addition to
the qla2xxx.

- version changed from 8.01.07-k7 to 8.02.00-k1.

The patch has been inlined and attached in a plain text format as well
just to provide alternative way for using it in the case where the
inlined not working.
Also, the same patch can be downloaded from following link,
ftp://ftp.qlogic.com/outgoing/linux/patches/8.x/8.02.00-k1/0002-qla2xxx-
Driver-version-chagne-to-reflect-NPIV-addit.patch

Signed-off-by: Seokmann Ju <seokmann.ju@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_version.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_version.h
b/drivers/scsi/qla2xxx/qla_version.h
index c375a4e..fd2f10a 100644
--- a/drivers/scsi/qla2xxx/qla_version.h
+++ b/drivers/scsi/qla2xxx/qla_version.h
@@ -7,9 +7,9 @@
 /*
  * Driver version
  */
-#define QLA2XXX_VERSION      "8.01.07-k7"
+#define QLA2XXX_VERSION      "8.02.00-k1"
=20
 #define QLA_DRIVER_MAJOR_VER	8
-#define QLA_DRIVER_MINOR_VER	1
-#define QLA_DRIVER_PATCH_VER	7
+#define QLA_DRIVER_MINOR_VER	2
+#define QLA_DRIVER_PATCH_VER	0
 #define QLA_DRIVER_BETA_VER	0
--=20
1.5.2.2.603.g7c851

------_=_NextPart_001_01C7BF41.8CB69EF4
Content-Type: application/octet-stream;
	name="0002-qla2xxx-Driver-version-chagne-to-reflect-NPIV-addit.patch"
Content-Transfer-Encoding: base64
Content-Description: 0002-qla2xxx-Driver-version-chagne-to-reflect-NPIV-addit.patch
Content-Disposition: attachment;
	filename="0002-qla2xxx-Driver-version-chagne-to-reflect-NPIV-addit.patch"

RnJvbSA5Njc3YjExY2Y3ODg5NTM0NjQ3MDk2ZjJkNzM3MzA1NWU3Zjk0NmM3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTZW9rbWFubiBKdSA8c2Vva21hbm4uanVAcWxvZ2ljLmNvbT4K
RGF0ZTogVGh1LCA1IEp1bCAyMDA3IDA4OjA5OjA0IC0wNzAwClN1YmplY3Q6IFtQQVRDSF0gcWxh
Mnh4eDogRHJpdmVyIHZlcnNpb24gY2hhZ25lIHRvIHJlZmxlY3QgTlBJViBhZGRpdGlvbi4KCi0g
dmVyc2lvbiBjaGFuZ2VkIGZyb20gOC4wMS4wNy1rNyB0byA4LjAyLjAwLWsxLgoKU2lnbmVkLW9m
Zi1ieTogU2Vva21hbm4gSnUgPHNlb2ttYW5uLmp1QHFsb2dpYy5jb20+Ci0tLQogZHJpdmVycy9z
Y3NpL3FsYTJ4eHgvcWxhX3ZlcnNpb24uaCB8ICAgIDYgKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Nj
c2kvcWxhMnh4eC9xbGFfdmVyc2lvbi5oIGIvZHJpdmVycy9zY3NpL3FsYTJ4eHgvcWxhX3ZlcnNp
b24uaAppbmRleCBjMzc1YTRlLi5mZDJmMTBhIDEwMDY0NAotLS0gYS9kcml2ZXJzL3Njc2kvcWxh
Mnh4eC9xbGFfdmVyc2lvbi5oCisrKyBiL2RyaXZlcnMvc2NzaS9xbGEyeHh4L3FsYV92ZXJzaW9u
LmgKQEAgLTcsOSArNyw5IEBACiAvKgogICogRHJpdmVyIHZlcnNpb24KICAqLwotI2RlZmluZSBR
TEEyWFhYX1ZFUlNJT04gICAgICAiOC4wMS4wNy1rNyIKKyNkZWZpbmUgUUxBMlhYWF9WRVJTSU9O
ICAgICAgIjguMDIuMDAtazEiCiAKICNkZWZpbmUgUUxBX0RSSVZFUl9NQUpPUl9WRVIJOAotI2Rl
ZmluZSBRTEFfRFJJVkVSX01JTk9SX1ZFUgkxCi0jZGVmaW5lIFFMQV9EUklWRVJfUEFUQ0hfVkVS
CTcKKyNkZWZpbmUgUUxBX0RSSVZFUl9NSU5PUl9WRVIJMgorI2RlZmluZSBRTEFfRFJJVkVSX1BB
VENIX1ZFUgkwCiAjZGVmaW5lIFFMQV9EUklWRVJfQkVUQV9WRVIJMAotLSAKMS41LjIuMi42MDMu
ZzdjODUxCgo=

------_=_NextPart_001_01C7BF41.8CB69EF4--
