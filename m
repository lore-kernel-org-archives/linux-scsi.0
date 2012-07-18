From: adam radford <aradford@gmail.com>
Subject: [PATCH 5/5] megaraid_sas: Version and Changelog update
Date: Tue, 17 Jul 2012 18:21:01 -0700
Message-ID: <CAHtARFE_DJ4+idki7TofSCoUOPcpFeoLENX33J=WjgNO5LsAyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=14dae9341237da1fde04c51079da
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52745 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab2GRBVC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 21:21:02 -0400
Received: by yhmm54 with SMTP id m54so1074966yhm.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 18:21:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--14dae9341237da1fde04c51079da
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates the driver version and
Documentation/scsi/ChangeLog.megaraid_sas files.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi/Documentation/scsi/ChangeLog.megaraid_sas
scsi.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi/Documentation/scsi/ChangeLog.megaraid_sas	2012-07-17
14:06:21.000000000 -0700
+++ scsi.new/Documentation/scsi/ChangeLog.megaraid_sas	2012-07-17
15:07:27.368388750 -0700
@@ -1,3 +1,13 @@
+Release Date    : Tue. Jun 17, 2012 17:00:00 PST 2012 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford/Kashyap Desai
+Current Version : 00.00.06.18-rc1
+Old Version     : 00.00.06.15-rc1
+    1. Fix Copyright dates.
+    2. Add throttlequeuedepth module parameter.
+    3. Add resetwaittime module parameter.
+    4. Move poll_aen_lock initializer.
+-------------------------------------------------------------------------------
 Release Date    : Mon. Mar 19, 2012 17:00:00 PST 2012 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas_base.c
scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
15:01:15.136294781 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-07-17
15:01:50.296168198 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.06.15-rc1
+ *  Version : v00.00.06.18-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi/drivers/scsi/megaraid/megaraid_sas.h
scsi.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi/drivers/scsi/megaraid/megaraid_sas.h	2012-07-17
14:44:04.342294076 -0700
+++ scsi.new/drivers/scsi/megaraid/megaraid_sas.h	2012-07-17
15:02:19.715232696 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.06.15-rc1"
-#define MEGASAS_RELDATE				"Mar. 19, 2012"
-#define MEGASAS_EXT_VERSION			"Mon. Mar. 19 17:00:00 PDT 2012"
+#define MEGASAS_VERSION				"00.00.06.18-rc1"
+#define MEGASAS_RELDATE				"Jun. 17, 2012"
+#define MEGASAS_EXT_VERSION			"Tue. Jun. 17 17:00:00 PDT 2012"

 /*
  * Device IDs

--14dae9341237da1fde04c51079da
Content-Type: application/octet-stream; name="megaraid_sas.patch5"
Content-Disposition: attachment; filename="megaraid_sas.patch5"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRfc2Fz
IHNjc2kubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRfc2FzCi0tLSBz
Y3NpL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRfc2FzCTIwMTItMDctMTcg
MTQ6MDY6MjEuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kv
Q2hhbmdlTG9nLm1lZ2FyYWlkX3NhcwkyMDEyLTA3LTE3IDE1OjA3OjI3LjM2ODM4ODc1MCAtMDcw
MApAQCAtMSwzICsxLDEzIEBACitSZWxlYXNlIERhdGUgICAgOiBUdWUuIEp1biAxNywgMjAxMiAx
NzowMDowMCBQU1QgMjAxMiAtCisJCQkoZW1haWxkLWlkOm1lZ2FyYWlkbGludXhAbHNpLmNvbSkK
KwkJCUFkYW0gUmFkZm9yZC9LYXNoeWFwIERlc2FpCitDdXJyZW50IFZlcnNpb24gOiAwMC4wMC4w
Ni4xOC1yYzEKK09sZCBWZXJzaW9uICAgICA6IDAwLjAwLjA2LjE1LXJjMQorICAgIDEuIEZpeCBD
b3B5cmlnaHQgZGF0ZXMuCisgICAgMi4gQWRkIHRocm90dGxlcXVldWVkZXB0aCBtb2R1bGUgcGFy
YW1ldGVyLgorICAgIDMuIEFkZCByZXNldHdhaXR0aW1lIG1vZHVsZSBwYXJhbWV0ZXIuCisgICAg
NC4gTW92ZSBwb2xsX2Flbl9sb2NrIGluaXRpYWxpemVyLgorLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LQogUmVsZWFzZSBEYXRlICAgIDogTW9uLiBNYXIgMTksIDIwMTIgMTc6MDA6MDAgUFNUIDIwMTIg
LQogCQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJCQlBZGFtIFJhZGZvcmQK
ZGlmZiAtTmF1ciBzY3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
IHNjc2kubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBz
Y3NpL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMDctMTcg
MTU6MDE6MTUuMTM2Mjk0NzgxIC0wNzAwCisrKyBzY3NpLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEyLTA3LTE3IDE1OjAxOjUwLjI5NjE2ODE5OCAtMDcw
MApAQCAtMTgsNyArMTgsNyBAQAogICogIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFj
ZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BIDAyMTExLTEzMDcgVVNBCiAgKgogICogIEZJTEU6IG1l
Z2FyYWlkX3Nhc19iYXNlLmMKLSAqICBWZXJzaW9uIDogdjAwLjAwLjA2LjE1LXJjMQorICogIFZl
cnNpb24gOiB2MDAuMDAuMDYuMTgtcmMxCiAgKgogICogIEF1dGhvcnM6IExTSSBDb3Jwb3JhdGlv
bgogICogICAgICAgICAgIFNyZWVuaXZhcyBCYWdhbGtvdGUKZGlmZiAtTmF1ciBzY3NpL2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBzY3NpLm5ldy9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2kvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhcy5oCTIwMTItMDctMTcgMTQ6NDQ6MDQuMzQyMjk0MDc2IC0wNzAwCisrKyBzY3NpLm5l
dy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMi0wNy0xNyAxNTowMjox
OS43MTUyMzI2OTYgLTA3MDAKQEAgLTMzLDkgKzMzLDkgQEAKIC8qCiAgKiBNZWdhUkFJRCBTQVMg
RHJpdmVyIG1ldGEgZGF0YQogICovCi0jZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQkiMDAuMDAu
MDYuMTUtcmMxIgotI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkJIk1hci4gMTksIDIwMTIiCi0j
ZGVmaW5lIE1FR0FTQVNfRVhUX1ZFUlNJT04JCQkiTW9uLiBNYXIuIDE5IDE3OjAwOjAwIFBEVCAy
MDEyIgorI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjAwLjAwLjA2LjE4LXJjMSIKKyNkZWZp
bmUgTUVHQVNBU19SRUxEQVRFCQkJCSJKdW4uIDE3LCAyMDEyIgorI2RlZmluZSBNRUdBU0FTX0VY
VF9WRVJTSU9OCQkJIlR1ZS4gSnVuLiAxNyAxNzowMDowMCBQRFQgMjAxMiIKIAogLyoKICAqIERl
dmljZSBJRHMK
--14dae9341237da1fde04c51079da--
