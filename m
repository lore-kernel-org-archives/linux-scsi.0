From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/4] megaraid_sas: Version and Changelog update
Date: Fri, 6 Jan 2012 17:02:45 -0800
Message-ID: <CAHtARFGpCxS8a2CgAZMQqDuz7ec+jZn7+qpb2VKu_+MnfSgotA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=f46d043bd86231a81404b5e5b9a9
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51273 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206Ab2AGBCr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jan 2012 20:02:47 -0500
Received: by wgbdr13 with SMTP id dr13so2243560wgb.1
        for <linux-scsi@vger.kernel.org>; Fri, 06 Jan 2012 17:02:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--f46d043bd86231a81404b5e5b9a9
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates the driver version and
updates Documentation/scsi/ChangeLog.megaraid_sas

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas	2012-02-06
12:50:05.000000000 -0800
+++ scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas	2012-01-06
15:20:11.109279477 -0800
@@ -1,3 +1,13 @@
+Release Date    : Fri. Jan 6, 2012 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.06.14-rc1
+Old Version     : 00.00.06.12-rc1
+    1. Fix reglockFlags for degraded raid5/6 for MR 9360/9380.
+    2. Mask off flags in ioctl path to prevent memory scribble with older
+       MegaCLI versions.
+    3. Remove poll_mode_io module paramater, sysfs node, and associated code.
+-------------------------------------------------------------------------------
 Release Date    : Wed. Oct 5, 2011 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2012-01-06
15:16:19.613372248 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-01-06
15:16:38.789372196 -0800
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.06.12-rc1
+ *  Version : v00.00.06.14-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2012-01-06
15:16:19.613372248 -0800
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2012-01-06
15:17:00.350279578 -0800
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.06.12-rc1"
-#define MEGASAS_RELDATE				"Oct. 5, 2011"
-#define MEGASAS_EXT_VERSION			"Wed. Oct. 5 17:00:00 PDT 2011"
+#define MEGASAS_VERSION				"00.00.06.14-rc1"
+#define MEGASAS_RELDATE				"Jan. 6, 2012"
+#define MEGASAS_EXT_VERSION			"Fri. Jan. 6 17:00:00 PDT 2012"

 /*
  * Device IDs

--f46d043bd86231a81404b5e5b9a9
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gx3xh0v00

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy0yLjYubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cu
bWVnYXJhaWRfc2FzCi0tLSBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VM
b2cubWVnYXJhaWRfc2FzCTIwMTItMDItMDYgMTI6NTA6MDUuMDAwMDAwMDAwIC0wODAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlkX3Nh
cwkyMDEyLTAxLTA2IDE1OjIwOjExLjEwOTI3OTQ3NyAtMDgwMApAQCAtMSwzICsxLDEzIEBACitS
ZWxlYXNlIERhdGUgICAgOiBGcmkuIEphbiA2LCAyMDEyIDE3OjAwOjAwIFBTVCAyMDEwIC0KKwkJ
CShlbWFpbGQtaWQ6bWVnYXJhaWRsaW51eEBsc2kuY29tKQorCQkJQWRhbSBSYWRmb3JkCitDdXJy
ZW50IFZlcnNpb24gOiAwMC4wMC4wNi4xNC1yYzEKK09sZCBWZXJzaW9uICAgICA6IDAwLjAwLjA2
LjEyLXJjMQorICAgIDEuIEZpeCByZWdsb2NrRmxhZ3MgZm9yIGRlZ3JhZGVkIHJhaWQ1LzYgZm9y
IE1SIDkzNjAvOTM4MC4KKyAgICAyLiBNYXNrIG9mZiBmbGFncyBpbiBpb2N0bCBwYXRoIHRvIHBy
ZXZlbnQgbWVtb3J5IHNjcmliYmxlIHdpdGggb2xkZXIKKyAgICAgICBNZWdhQ0xJIHZlcnNpb25z
LgorICAgIDMuIFJlbW92ZSBwb2xsX21vZGVfaW8gbW9kdWxlIHBhcmFtYXRlciwgc3lzZnMgbm9k
ZSwgYW5kIGFzc29jaWF0ZWQgY29kZS4KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIFJlbGVhc2Ug
RGF0ZSAgICA6IFdlZC4gT2N0IDUsIDIwMTEgMTc6MDA6MDAgUFNUIDIwMTAgLQogCQkJKGVtYWls
ZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJCQlBZGFtIFJhZGZvcmQKZGlmZiAtTmF1ciBz
Y3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jIHNj
c2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
Ci0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTItMDEtMDYgMTU6MTY6MTkuNjEzMzcyMjQ4IC0wODAwCisrKyBzY3NpLW1pc2MtMi42
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEyLTAxLTA2
IDE1OjE2OjM4Ljc4OTM3MjE5NiAtMDgwMApAQCAtMTgsNyArMTgsNyBAQAogICogIEZvdW5kYXRp
b24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BIDAyMTExLTEz
MDcgVVNBCiAgKgogICogIEZJTEU6IG1lZ2FyYWlkX3Nhc19iYXNlLmMKLSAqICBWZXJzaW9uIDog
djAwLjAwLjA2LjEyLXJjMQorICogIFZlcnNpb24gOiB2MDAuMDAuMDYuMTQtcmMxCiAgKgogICog
IEF1dGhvcnM6IExTSSBDb3Jwb3JhdGlvbgogICogICAgICAgICAgIFNyZWVuaXZhcyBCYWdhbGtv
dGUKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaCBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzLmgKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nh
cy5oCTIwMTItMDEtMDYgMTU6MTY6MTkuNjEzMzcyMjQ4IC0wODAwCisrKyBzY3NpLW1pc2MtMi42
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMi0wMS0wNiAxNTox
NzowMC4zNTAyNzk1NzggLTA4MDAKQEAgLTMzLDkgKzMzLDkgQEAKIC8qCiAgKiBNZWdhUkFJRCBT
QVMgRHJpdmVyIG1ldGEgZGF0YQogICovCi0jZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDAu
MDAuMDYuMTItcmMxIgotI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkJIk9jdC4gNSwgMjAxMSIK
LSNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJXZWQuIE9jdC4gNSAxNzowMDowMCBQRFQg
MjAxMSIKKyNkZWZpbmUgTUVHQVNBU19WRVJTSU9OCQkJCSIwMC4wMC4wNi4xNC1yYzEiCisjZGVm
aW5lIE1FR0FTQVNfUkVMREFURQkJCQkiSmFuLiA2LCAyMDEyIgorI2RlZmluZSBNRUdBU0FTX0VY
VF9WRVJTSU9OCQkJIkZyaS4gSmFuLiA2IDE3OjAwOjAwIFBEVCAyMDEyIgogCiAvKgogICogRGV2
aWNlIElEcwo=
--f46d043bd86231a81404b5e5b9a9--
