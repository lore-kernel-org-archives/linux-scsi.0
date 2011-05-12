From: adam radford <aradford@gmail.com>
Subject: [PATCH 8/8] megaraid_sas: Version and Changelog update
Date: Wed, 11 May 2011 18:35:05 -0700
Message-ID: <BANLkTimMK5_Vy=jiNqcVR0dLzEum-PkpaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636426b6bdcf4b604a30a32b0
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57992 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab1ELBfF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 May 2011 21:35:05 -0400
Received: by mail-qy0-f174.google.com with SMTP id 7so2650853qyk.19
        for <linux-scsi@vger.kernel.org>; Wed, 11 May 2011 18:35:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001636426b6bdcf4b604a30a32b0
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adjusts the version and updates
ChangeLog.megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc/Documentation/scsi/ChangeLog.megaraid_sas	2011-05-09
19:33:54.000000000 -0700
+++ scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas	2011-05-11
16:18:56.970367055 -0700
@@ -1,3 +1,17 @@
+Release Date    : Wed. May 11, 2011 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.05.38-rc1
+Old Version     : 00.00.05.34-rc1
+    1. Remove MSI-X black list, use MFI_REG_STATE.ready.msiEnable.
+    2. Remove un-used function megasas_return_cmd_for_smid().
+    3. Check MFI_REG_STATE.fault.resetAdapter in megasas_reset_fusion().
+    4. Disable interrupts/free_irq() in megasas_shutdown().
+    5. Fix bug where AENs could be lost in probe() and resume().
+    6. Convert 6,10,12 byte CDB's to 16 byte CDB for large LBA's for FastPath
+       IO.
+    7. Add 1078 OCR support.
+-------------------------------------------------------------------------------
 Release Date    : Thu. Feb 24, 2011 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
16:12:54.963400403 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-05-11
16:13:39.277428796 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.05.34-rc1
+ *  Version : v00.00.05.38-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas.h	2011-05-11
15:00:38.730367313 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h	2011-05-11
16:14:16.896368088 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.05.34-rc1"
-#define MEGASAS_RELDATE				"Feb. 24, 2011"
-#define MEGASAS_EXT_VERSION			"Thu. Feb. 24 17:00:00 PDT 2011"
+#define MEGASAS_VERSION				"00.00.05.38-rc1"
+#define MEGASAS_RELDATE				"May. 11, 2011"
+#define MEGASAS_EXT_VERSION			"Wed. May. 11 17:00:00 PDT 2011"

 /*
  * Device IDs

--001636426b6bdcf4b604a30a32b0
Content-Type: application/octet-stream; name="megaraid_sas.patch8"
Content-Disposition: attachment; filename="megaraid_sas.patch8"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gnl0uyxn0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFp
ZF9zYXMgc2NzaS1taXNjLm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlk
X3NhcwotLS0gc2NzaS1taXNjL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRf
c2FzCTIwMTEtMDUtMDkgMTk6MzM6NTQuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRfc2FzCTIwMTEtMDUtMTEgMTY6
MTg6NTYuOTcwMzY3MDU1IC0wNzAwCkBAIC0xLDMgKzEsMTcgQEAKK1JlbGVhc2UgRGF0ZSAgICA6
IFdlZC4gTWF5IDExLCAyMDExIDE3OjAwOjAwIFBTVCAyMDEwIC0KKwkJCShlbWFpbGQtaWQ6bWVn
YXJhaWRsaW51eEBsc2kuY29tKQorCQkJQWRhbSBSYWRmb3JkCitDdXJyZW50IFZlcnNpb24gOiAw
MC4wMC4wNS4zOC1yYzEKK09sZCBWZXJzaW9uICAgICA6IDAwLjAwLjA1LjM0LXJjMQorICAgIDEu
IFJlbW92ZSBNU0ktWCBibGFjayBsaXN0LCB1c2UgTUZJX1JFR19TVEFURS5yZWFkeS5tc2lFbmFi
bGUuCisgICAgMi4gUmVtb3ZlIHVuLXVzZWQgZnVuY3Rpb24gbWVnYXNhc19yZXR1cm5fY21kX2Zv
cl9zbWlkKCkuCisgICAgMy4gQ2hlY2sgTUZJX1JFR19TVEFURS5mYXVsdC5yZXNldEFkYXB0ZXIg
aW4gbWVnYXNhc19yZXNldF9mdXNpb24oKS4KKyAgICA0LiBEaXNhYmxlIGludGVycnVwdHMvZnJl
ZV9pcnEoKSBpbiBtZWdhc2FzX3NodXRkb3duKCkuCisgICAgNS4gRml4IGJ1ZyB3aGVyZSBBRU5z
IGNvdWxkIGJlIGxvc3QgaW4gcHJvYmUoKSBhbmQgcmVzdW1lKCkuCisgICAgNi4gQ29udmVydCA2
LDEwLDEyIGJ5dGUgQ0RCJ3MgdG8gMTYgYnl0ZSBDREIgZm9yIGxhcmdlIExCQSdzIGZvciBGYXN0
UGF0aAorICAgICAgIElPLgorICAgIDcuIEFkZCAxMDc4IE9DUiBzdXBwb3J0LgorLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLQogUmVsZWFzZSBEYXRlICAgIDogVGh1LiBGZWIgMjQsIDIwMTEgMTc6MDA6
MDAgUFNUIDIwMTAgLQogCQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJCQlB
ZGFtIFJhZGZvcmQKZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19iYXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMDUtMTEgMTY6MTI6NTQuOTYzNDAwNDAzIC0wNzAwCisrKyBz
Y3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIw
MTEtMDUtMTEgMTY6MTM6MzkuMjc3NDI4Nzk2IC0wNzAwCkBAIC0xOCw3ICsxOCw3IEBACiAgKiAg
Rm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEg
MDIxMTEtMTMwNyBVU0EKICAqCiAgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Jhc2UuYwotICogIFZl
cnNpb24gOiB2MDAuMDAuMDUuMzQtcmMxCisgKiAgVmVyc2lvbiA6IHYwMC4wMC4wNS4zOC1yYzEK
ICAqCiAgKiAgQXV0aG9yczogTFNJIENvcnBvcmF0aW9uCiAgKiAgICAgICAgICAgU3JlZW5pdmFz
IEJhZ2Fsa290ZQpkaWZmIC1OYXVyIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzLmggc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzLmgKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJ
MjAxMS0wNS0xMSAxNTowMDozOC43MzAzNjczMTMgLTA3MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJp
dmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTEtMDUtMTEgMTY6MTQ6MTYuODk2
MzY4MDg4IC0wNzAwCkBAIC0zMyw5ICszMyw5IEBACiAvKgogICogTWVnYVJBSUQgU0FTIERyaXZl
ciBtZXRhIGRhdGEKICAqLwotI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjAwLjAwLjA1LjM0
LXJjMSIKLSNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJCSJGZWIuIDI0LCAyMDExIgotI2RlZmlu
ZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkJIlRodS4gRmViLiAyNCAxNzowMDowMCBQRFQgMjAxMSIK
KyNkZWZpbmUgTUVHQVNBU19WRVJTSU9OCQkJCSIwMC4wMC4wNS4zOC1yYzEiCisjZGVmaW5lIE1F
R0FTQVNfUkVMREFURQkJCQkiTWF5LiAxMSwgMjAxMSIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVS
U0lPTgkJCSJXZWQuIE1heS4gMTEgMTc6MDA6MDAgUERUIDIwMTEiCiAKIC8qCiAgKiBEZXZpY2Ug
SURzCg==
--001636426b6bdcf4b604a30a32b0--
