From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/2] megaraid_sas: Version and Changelog update
Date: Sat, 31 Aug 2013 16:54:28 -0700
Message-ID: <CAHtARFEW=5rxzUv+3h=0Ju+iimPLY4-pQZ5XTjEafXawv4kPWQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b677e584bfcf904e5470f36
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f43.google.com ([209.85.128.43]:49726 "EHLO
	mail-qe0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128Ab3HaXyb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Aug 2013 19:54:31 -0400
Received: by mail-qe0-f43.google.com with SMTP id t7so1682632qeb.30
        for <linux-scsi@vger.kernel.org>; Sat, 31 Aug 2013 16:54:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

--047d7b677e584bfcf904e5470f36
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch updates the megaraid_sas driver version and updates
Documentation/ChangeLog.megaraid_sas

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc.old/Documentation/scsi/ChangeLog.megaraid_sas 2013-08-25
17:43:22.000000000 -0700
+++ scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas 2013-08-31
16:09:54.273079869 -0700
@@ -1,3 +1,13 @@
+Release Date    : Sat. Aug 31, 2013 17:00:00 PST 2013 -
+ (emaild-id:megaraidlinux@lsi.com)
+ Adam Radford
+ Kashyap Desai
+ Sumit Saxena
+Current Version : 06.700.06.00-rc1
+Old Version     : 06.600.18.00-rc1
+    1. Add High Availability clustering support using shared Logical Disks.
+    2. Version and Changelog update.
+-------------------------------------------------------------------------------
 Release Date    : Wed. May 15, 2013 17:00:00 PST 2013 -
  (emaild-id:megaraidlinux@lsi.com)
  Adam Radford
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c 2013-08-31
16:05:24.341172944 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c 2013-08-31
16:07:04.985077563 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : 06.600.18.00-rc1
+ *  Version : 06.700.06.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h 2013-08-31
16:05:24.394079466 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h 2013-08-31
16:06:48.461080925 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION "06.600.18.00-rc1"
-#define MEGASAS_RELDATE "May. 15, 2013"
-#define MEGASAS_EXT_VERSION "Wed. May. 15 17:00:00 PDT 2013"
+#define MEGASAS_VERSION "06.700.06.00-rc1"
+#define MEGASAS_RELDATE "Aug. 31, 2013"
+#define MEGASAS_EXT_VERSION "Sat. Aug. 31 17:00:00 PDT 2013"

 /*
  * Device IDs

--047d7b677e584bfcf904e5470f36
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hl1hj35w0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy5uZXcvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdh
cmFpZF9zYXMKLS0tIHNjc2ktbWlzYy5vbGQvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5t
ZWdhcmFpZF9zYXMJMjAxMy0wOC0yNSAxNzo0MzoyMi4wMDAwMDAwMDAgLTA3MDAKKysrIHNjc2kt
bWlzYy5uZXcvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFpZF9zYXMJMjAxMy0w
OC0zMSAxNjowOTo1NC4yNzMwNzk4NjkgLTA3MDAKQEAgLTEsMyArMSwxMyBAQAorUmVsZWFzZSBE
YXRlICAgIDogU2F0LiBBdWcgMzEsIDIwMTMgMTc6MDA6MDAgUFNUIDIwMTMgLQorCQkJKGVtYWls
ZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCisJCQlBZGFtIFJhZGZvcmQKKwkJCUthc2h5YXAg
RGVzYWkKKwkJCVN1bWl0IFNheGVuYQorQ3VycmVudCBWZXJzaW9uIDogMDYuNzAwLjA2LjAwLXJj
MQorT2xkIFZlcnNpb24gICAgIDogMDYuNjAwLjE4LjAwLXJjMQorICAgIDEuIEFkZCBIaWdoIEF2
YWlsYWJpbGl0eSBjbHVzdGVyaW5nIHN1cHBvcnQgdXNpbmcgc2hhcmVkIExvZ2ljYWwgRGlza3Mu
CisgICAgMi4gVmVyc2lvbiBhbmQgQ2hhbmdlbG9nIHVwZGF0ZS4KKy0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0KIFJlbGVhc2UgRGF0ZSAgICA6IFdlZC4gTWF5IDE1LCAyMDEzIDE3OjAwOjAwIFBTVCAy
MDEzIC0KIAkJCShlbWFpbGQtaWQ6bWVnYXJhaWRsaW51eEBsc2kuY29tKQogCQkJQWRhbSBSYWRm
b3JkCmRpZmYgLU5hdXIgc2NzaS1taXNjLm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Jhc2UuYyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTMtMDgtMzEgMTY6MDU6MjQuMzQxMTcyOTQ0IC0wNzAwCisrKyBz
Y3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIw
MTMtMDgtMzEgMTY6MDc6MDQuOTg1MDc3NTYzIC0wNzAwCkBAIC0xOCw3ICsxOCw3IEBACiAgKiAg
Rm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEg
MDIxMTEtMTMwNyBVU0EKICAqCiAgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Jhc2UuYwotICogIFZl
cnNpb24gOiAwNi42MDAuMTguMDAtcmMxCisgKiAgVmVyc2lvbiA6IDA2LjcwMC4wNi4wMC1yYzEK
ICAqCiAgKiAgQXV0aG9yczogTFNJIENvcnBvcmF0aW9uCiAgKiAgICAgICAgICAgU3JlZW5pdmFz
IEJhZ2Fsa290ZQpkaWZmIC1OYXVyIHNjc2ktbWlzYy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhcy5oIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhcy5oCi0tLSBzY3NpLW1pc2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaAkyMDEzLTA4LTMxIDE2OjA1OjI0LjM5NDA3OTQ2NiAtMDcwMAorKysgc2NzaS1taXNj
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMy0wOC0zMSAxNjow
Njo0OC40NjEwODA5MjUgLTA3MDAKQEAgLTMzLDkgKzMzLDkgQEAKIC8qCiAgKiBNZWdhUkFJRCBT
QVMgRHJpdmVyIG1ldGEgZGF0YQogICovCi0jZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDYu
NjAwLjE4LjAwLXJjMSIKLSNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJCSJNYXkuIDE1LCAyMDEz
IgotI2RlZmluZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkJIldlZC4gTWF5LiAxNSAxNzowMDowMCBQ
RFQgMjAxMyIKKyNkZWZpbmUgTUVHQVNBU19WRVJTSU9OCQkJCSIwNi43MDAuMDYuMDAtcmMxIgor
I2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkJIkF1Zy4gMzEsIDIwMTMiCisjZGVmaW5lIE1FR0FT
QVNfRVhUX1ZFUlNJT04JCQkiU2F0LiBBdWcuIDMxIDE3OjAwOjAwIFBEVCAyMDEzIgogCiAvKgog
ICogRGV2aWNlIElEcwo=
--047d7b677e584bfcf904e5470f36--
