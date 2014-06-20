From: adam radford <aradford@gmail.com>
Subject: [PATCH 4/4] megaraid_sas: Version and Changelog update
Date: Thu, 19 Jun 2014 17:32:10 -0700
Message-ID: <CAHtARFGBCr+vQ1qbiruhXTK1p9mreJVB14yvi-2+Z5gfOThDCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf304353a8d706f404fc399fc7
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:49236 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753688AbaFTAcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jun 2014 20:32:12 -0400
Received: by mail-yh0-f47.google.com with SMTP id v1so2315077yhn.20
        for <linux-scsi@vger.kernel.org>; Thu, 19 Jun 2014 17:32:11 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com

--20cf304353a8d706f404fc399fc7
Content-Type: text/plain; charset=UTF-8

James/linux-scsi,

The following patch for megaraid_sas updates the driver version and
Documentation/scsi/ChangeLog.megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-for-next.old/Documentation/scsi/ChangeLog.megaraid_sas
scsi-for-next.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-for-next.old/Documentation/scsi/ChangeLog.megaraid_sas
2014-06-19 15:03:01.000000000 -0700
+++ scsi-for-next.new/Documentation/scsi/ChangeLog.megaraid_sas
2014-06-19 16:00:07.867075774 -0700
@@ -1,3 +1,16 @@
+Release Date    : Thu. Jun 19, 2014 17:00:00 PST 2014 -
+ (emaild-id:megaraidlinux@lsi.com)
+ Adam Radford
+ Kashyap Desai
+ Sumit Saxena
+ Uday Lingala
+Current Version : 06.803.02.00-rc1
+Old Version     : 06.803.01.00-rc1
+    1. Fix reset_mutex leak in megasas_reset_fusion().
+    2. Remove unused variables in megasas_instance.
+    3. Fix LD/VF affiliation parsing.
+    4. Version and Changelog update.
+-------------------------------------------------------------------------------
 Release Date    : Mon. Mar 10, 2014 17:00:00 PST 2014 -
  (emaild-id:megaraidlinux@lsi.com)
  Adam Radford
diff -Naur scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas_base.c
2014-06-19 15:55:05.470199777 -0700
+++ scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas_base.c
2014-06-19 15:55:33.465167518 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : 06.803.01.00-rc1
+ *  Version : 06.803.02.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-for-next.old/drivers/scsi/megaraid/megaraid_sas.h 2014-06-19
15:55:05.499074636 -0700
+++ scsi-for-next.new/drivers/scsi/megaraid/megaraid_sas.h 2014-06-19
15:56:17.128075741 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION "06.803.01.00-rc1"
-#define MEGASAS_RELDATE "Mar. 10, 2014"
-#define MEGASAS_EXT_VERSION "Mon. Mar. 10 17:00:00 PDT 2014"
+#define MEGASAS_VERSION "06.803.02.00-rc1"
+#define MEGASAS_RELDATE "Jun. 19, 2014"
+#define MEGASAS_EXT_VERSION "Thu. Jun. 19 17:00:00 PDT 2014"

 /*
  * Device IDs

--20cf304353a8d706f404fc399fc7
Content-Type: application/octet-stream; name="megaraid_sas.patch4"
Content-Disposition: attachment; filename="megaraid_sas.patch4"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hwmrg4y90

ZGlmZiAtTmF1ciBzY3NpLWZvci1uZXh0Lm9sZC9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9n
Lm1lZ2FyYWlkX3NhcyBzY3NpLWZvci1uZXh0Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdl
TG9nLm1lZ2FyYWlkX3NhcwotLS0gc2NzaS1mb3ItbmV4dC5vbGQvRG9jdW1lbnRhdGlvbi9zY3Np
L0NoYW5nZUxvZy5tZWdhcmFpZF9zYXMJMjAxNC0wNi0xOSAxNTowMzowMS4wMDAwMDAwMDAgLTA3
MDAKKysrIHNjc2ktZm9yLW5leHQubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzCTIwMTQtMDYtMTkgMTY6MDA6MDcuODY3MDc1Nzc0IC0wNzAwCkBAIC0xLDMgKzEs
MTYgQEAKK1JlbGVhc2UgRGF0ZSAgICA6IFRodS4gSnVuIDE5LCAyMDE0IDE3OjAwOjAwIFBTVCAy
MDE0IC0KKwkJCShlbWFpbGQtaWQ6bWVnYXJhaWRsaW51eEBsc2kuY29tKQorCQkJQWRhbSBSYWRm
b3JkCisJCQlLYXNoeWFwIERlc2FpCisJCQlTdW1pdCBTYXhlbmEKKwkJCVVkYXkgTGluZ2FsYQor
Q3VycmVudCBWZXJzaW9uIDogMDYuODAzLjAyLjAwLXJjMQorT2xkIFZlcnNpb24gICAgIDogMDYu
ODAzLjAxLjAwLXJjMQorICAgIDEuIEZpeCByZXNldF9tdXRleCBsZWFrIGluIG1lZ2FzYXNfcmVz
ZXRfZnVzaW9uKCkuCisgICAgMi4gUmVtb3ZlIHVudXNlZCB2YXJpYWJsZXMgaW4gbWVnYXNhc19p
bnN0YW5jZS4KKyAgICAzLiBGaXggTEQvVkYgYWZmaWxpYXRpb24gcGFyc2luZy4KKyAgICA0LiBW
ZXJzaW9uIGFuZCBDaGFuZ2Vsb2cgdXBkYXRlLgorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogUmVs
ZWFzZSBEYXRlICAgIDogTW9uLiBNYXIgMTAsIDIwMTQgMTc6MDA6MDAgUFNUIDIwMTQgLQogCQkJ
KGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJCQlBZGFtIFJhZGZvcmQKZGlmZiAt
TmF1ciBzY3NpLWZvci1uZXh0Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Jhc2UuYyBzY3NpLWZvci1uZXh0Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Jhc2UuYwotLS0gc2NzaS1mb3ItbmV4dC5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19iYXNlLmMJMjAxNC0wNi0xOSAxNTo1NTowNS40NzAxOTk3NzcgLTA3MDAKKysr
IHNjc2ktZm9yLW5leHQubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFz
ZS5jCTIwMTQtMDYtMTkgMTU6NTU6MzMuNDY1MTY3NTE4IC0wNzAwCkBAIC0xOCw3ICsxOCw3IEBA
CiAgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3Rv
biwgTUEgMDIxMTEtMTMwNyBVU0EKICAqCiAgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Jhc2UuYwot
ICogIFZlcnNpb24gOiAwNi44MDMuMDEuMDAtcmMxCisgKiAgVmVyc2lvbiA6IDA2LjgwMy4wMi4w
MC1yYzEKICAqCiAgKiAgQXV0aG9yczogTFNJIENvcnBvcmF0aW9uCiAgKiAgICAgICAgICAgU3Jl
ZW5pdmFzIEJhZ2Fsa290ZQpkaWZmIC1OYXVyIHNjc2ktZm9yLW5leHQub2xkL2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBzY3NpLWZvci1uZXh0Lm5ldy9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktZm9yLW5leHQub2xkL2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDE0LTA2LTE5IDE1OjU1OjA1LjQ5OTA3NDYzNiAt
MDcwMAorKysgc2NzaS1mb3ItbmV4dC5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhcy5oCTIwMTQtMDYtMTkgMTU6NTY6MTcuMTI4MDc1NzQxIC0wNzAwCkBAIC0zMyw5ICszMyw5
IEBACiAvKgogICogTWVnYVJBSUQgU0FTIERyaXZlciBtZXRhIGRhdGEKICAqLwotI2RlZmluZSBN
RUdBU0FTX1ZFUlNJT04JCQkJIjA2LjgwMy4wMS4wMC1yYzEiCi0jZGVmaW5lIE1FR0FTQVNfUkVM
REFURQkJCQkiTWFyLiAxMCwgMjAxNCIKLSNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJN
b24uIE1hci4gMTAgMTc6MDA6MDAgUERUIDIwMTQiCisjZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJ
CQkiMDYuODAzLjAyLjAwLXJjMSIKKyNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJCSJKdW4uIDE5
LCAyMDE0IgorI2RlZmluZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkJIlRodS4gSnVuLiAxOSAxNzow
MDowMCBQRFQgMjAxNCIKIAogLyoKICAqIERldmljZSBJRHMK
--20cf304353a8d706f404fc399fc7--
