From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/3] megaraid_sas: Version and Changelog update
Date: Mon, 19 Mar 2012 19:50:06 -0700
Message-ID: <CAHtARFFttADooUiUxa_R0cqTxY0b9aRm2qiFaNjzEZNg_4=pXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6d45fbe81cb5204bba3bb16
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35837 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab2CTCuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Mar 2012 22:50:08 -0400
Received: by wejx9 with SMTP id x9so6375509wej.19
        for <linux-scsi@vger.kernel.org>; Mon, 19 Mar 2012 19:50:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6d45fbe81cb5204bba3bb16
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates the driver version to
v00.00.06.15-rc1, and updates
Documentation/scsi/ChangeLog.megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas	2012-03-19
17:39:03.891862584 -0700
+++ scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas	2012-03-19
18:12:07.557862937 -0700
@@ -1,3 +1,11 @@
+Release Date    : Mon. Mar 19, 2012 17:00:00 PST 2012 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.06.15-rc1
+Old Version     : 00.00.06.14-rc1
+    1. Optimize HostMSIxVectors setting.
+    2. Add fpRead/WriteCapable, fpRead/WriteAcrossStripe checks.
+-------------------------------------------------------------------------------
 Release Date    : Fri. Jan 6, 2012 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2012-03-19
17:39:08.313986900 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-03-19
17:59:35.357956192 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.06.14-rc1
+ *  Version : v00.00.06.15-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2012-03-19
17:39:08.312986814 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2012-03-19
17:59:57.250862947 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.06.14-rc1"
-#define MEGASAS_RELDATE				"Jan. 6, 2012"
-#define MEGASAS_EXT_VERSION			"Fri. Jan. 6 17:00:00 PDT 2012"
+#define MEGASAS_VERSION				"00.00.06.15-rc1"
+#define MEGASAS_RELDATE				"Mar. 19, 2012"
+#define MEGASAS_EXT_VERSION			"Mon. Mar. 19 17:00:00 PDT 2012"

 /*
  * Device IDs

--0016e6d45fbe81cb5204bba3bb16
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h00cfe2k0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy0yLjYubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cu
bWVnYXJhaWRfc2FzCi0tLSBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VM
b2cubWVnYXJhaWRfc2FzCTIwMTItMDMtMTkgMTc6Mzk6MDMuODkxODYyNTg0IC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlkX3Nh
cwkyMDEyLTAzLTE5IDE4OjEyOjA3LjU1Nzg2MjkzNyAtMDcwMApAQCAtMSwzICsxLDExIEBACitS
ZWxlYXNlIERhdGUgICAgOiBNb24uIE1hciAxOSwgMjAxMiAxNzowMDowMCBQU1QgMjAxMiAtCisJ
CQkoZW1haWxkLWlkOm1lZ2FyYWlkbGludXhAbHNpLmNvbSkKKwkJCUFkYW0gUmFkZm9yZAorQ3Vy
cmVudCBWZXJzaW9uIDogMDAuMDAuMDYuMTUtcmMxCitPbGQgVmVyc2lvbiAgICAgOiAwMC4wMC4w
Ni4xNC1yYzEKKyAgICAxLiBPcHRpbWl6ZSBIb3N0TVNJeFZlY3RvcnMgc2V0dGluZy4KKyAgICAy
LiBBZGQgZnBSZWFkL1dyaXRlQ2FwYWJsZSwgZnBSZWFkL1dyaXRlQWNyb3NzU3RyaXBlIGNoZWNr
cy4KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIFJlbGVhc2UgRGF0ZSAgICA6IEZyaS4gSmFuIDYs
IDIwMTIgMTc6MDA6MDAgUFNUIDIwMTAgLQogCQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxz
aS5jb20pCiAJCQlBZGFtIFJhZGZvcmQKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMDMtMTkgMTc6Mzk6
MDguMzEzOTg2OTAwIC0wNzAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEyLTAzLTE5IDE3OjU5OjM1LjM1Nzk1NjE5MiAt
MDcwMApAQCAtMTgsNyArMTgsNyBAQAogICogIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQ
bGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BIDAyMTExLTEzMDcgVVNBCiAgKgogICogIEZJTEU6
IG1lZ2FyYWlkX3Nhc19iYXNlLmMKLSAqICBWZXJzaW9uIDogdjAwLjAwLjA2LjE0LXJjMQorICog
IFZlcnNpb24gOiB2MDAuMDAuMDYuMTUtcmMxCiAgKgogICogIEF1dGhvcnM6IExTSSBDb3Jwb3Jh
dGlvbgogICogICAgICAgICAgIFNyZWVuaXZhcyBCYWdhbGtvdGUKZGlmZiAtTmF1ciBzY3NpLW1p
c2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBzY3NpLW1pc2MtMi42
Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy0y
LjYvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTItMDMtMTkgMTc6Mzk6
MDguMzEyOTg2ODE0IC0wNzAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMi0wMy0xOSAxNzo1OTo1Ny4yNTA4NjI5NDcgLTA3MDAK
QEAgLTMzLDkgKzMzLDkgQEAKIC8qCiAgKiBNZWdhUkFJRCBTQVMgRHJpdmVyIG1ldGEgZGF0YQog
ICovCi0jZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDAuMDAuMDYuMTQtcmMxIgotI2RlZmlu
ZSBNRUdBU0FTX1JFTERBVEUJCQkJIkphbi4gNiwgMjAxMiIKLSNkZWZpbmUgTUVHQVNBU19FWFRf
VkVSU0lPTgkJCSJGcmkuIEphbi4gNiAxNzowMDowMCBQRFQgMjAxMiIKKyNkZWZpbmUgTUVHQVNB
U19WRVJTSU9OCQkJCSIwMC4wMC4wNi4xNS1yYzEiCisjZGVmaW5lIE1FR0FTQVNfUkVMREFURQkJ
CQkiTWFyLiAxOSwgMjAxMiIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJNb24uIE1h
ci4gMTkgMTc6MDA6MDAgUERUIDIwMTIiCiAKIC8qCiAgKiBEZXZpY2UgSURzCg==
--0016e6d45fbe81cb5204bba3bb16--
