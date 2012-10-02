From: adam radford <aradford@gmail.com>
Subject: [PATCH 7/7] megaraid_sas: Version, Changelog, Copyright update
Date: Mon, 1 Oct 2012 19:27:34 -0700
Message-ID: <CAHtARFG-ADNn2-ZmPQSc4ua=TS7qr0MqO3RopNWLjEpPTC77+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf307ca2c0d7a88d04cb0a4388
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48521 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758045Ab2JBC1f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Oct 2012 22:27:35 -0400
Received: by mail-vc0-f174.google.com with SMTP id fo13so6426342vcb.19
        for <linux-scsi@vger.kernel.org>; Mon, 01 Oct 2012 19:27:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <Kashyap.Desai@lsi.com>

--20cf307ca2c0d7a88d04cb0a4388
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates the driver version,
Changelog.megaraid_sas, and Copyright dates.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc/Documentation/scsi/ChangeLog.megaraid_sas	2012-10-01
15:51:15.150956861 -0700
+++ scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas	2012-10-01
17:19:57.356863501 -0700
@@ -1,3 +1,16 @@
+Release Date    : Mon. Oct 1, 2012 17:00:00 PST 2012 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 06.504.01.00-rc1
+Old Version     : 00.00.06.18-rc1
+    1. Removed un-needed completion_lock spinlock calls.
+    2. Add module param for configurable MSI-X vector count.
+    3. Load io_request DataLength in bytes.
+    4. Add array boundary check for SystemPD.
+    5. Add SystemPD FastPath support.
+    6. Remove duplicate code.
+    7. Version, Changelog, Copyright update.
+-------------------------------------------------------------------------------
 Release Date    : Tue. Jun 17, 2012 17:00:00 PST 2012 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford/Kashyap Desai
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2012-10-01
17:15:14.496925509 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2012-10-01
17:21:15.286955566 -0700
@@ -1,7 +1,7 @@
 /*
  *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *  Copyright (c) 2009-2011  LSI Corporation.
+ *  Copyright (c) 2003-2012  LSI Corporation.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.06.18-rc1
+ *  Version : v06.504.01.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fp.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fp.c	2012-09-30
16:47:46.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2012-10-01
17:22:14.369863606 -0700
@@ -1,7 +1,7 @@
 /*
  *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *  Copyright (c) 2009-2011  LSI Corporation.
+ *  Copyright (c) 2009-2012  LSI Corporation.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:15:14.497925080 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2012-10-01
17:21:51.922862954 -0700
@@ -1,7 +1,7 @@
 /*
  *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *  Copyright (c) 2009-2011  LSI Corporation.
+ *  Copyright (c) 2009-2012  LSI Corporation.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_fusion.h	2012-09-30
16:47:46.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2012-10-01
17:22:06.376863741 -0700
@@ -1,7 +1,7 @@
 /*
  *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *  Copyright (c) 2009-2011  LSI Corporation.
+ *  Copyright (c) 2009-2012  LSI Corporation.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas.h	2012-10-01
15:51:15.216956204 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h	2012-10-01
17:21:36.260863781 -0700
@@ -1,7 +1,7 @@
 /*
  *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *  Copyright (c) 2009-2011  LSI Corporation.
+ *  Copyright (c) 2003-2012  LSI Corporation.
  *
  *  This program is free software; you can redistribute it and/or
  *  modify it under the terms of the GNU General Public License
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.06.18-rc1"
-#define MEGASAS_RELDATE				"Jun. 17, 2012"
-#define MEGASAS_EXT_VERSION			"Tue. Jun. 17 17:00:00 PDT 2012"
+#define MEGASAS_VERSION				"06.504.01.00-rc1"
+#define MEGASAS_RELDATE				"Oct. 1, 2012"
+#define MEGASAS_EXT_VERSION			"Mon. Oct. 1 17:00:00 PDT 2012"

 /*
  * Device IDs

--20cf307ca2c0d7a88d04cb0a4388
Content-Type: application/octet-stream; name="megaraid_sas.patch7"
Content-Disposition: attachment; filename="megaraid_sas.patch7"
Content-Transfer-Encoding: base64
X-Attachment-Id: file0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFp
ZF9zYXMgc2NzaS1taXNjLm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlk
X3NhcwotLS0gc2NzaS1taXNjL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRf
c2FzCTIwMTItMTAtMDEgMTU6NTE6MTUuMTUwOTU2ODYxIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRfc2FzCTIwMTItMTAtMDEgMTc6
MTk6NTcuMzU2ODYzNTAxIC0wNzAwCkBAIC0xLDMgKzEsMTYgQEAKK1JlbGVhc2UgRGF0ZSAgICA6
IE1vbi4gT2N0IDEsIDIwMTIgMTc6MDA6MDAgUFNUIDIwMTIgLQorCQkJKGVtYWlsZC1pZDptZWdh
cmFpZGxpbnV4QGxzaS5jb20pCisJCQlBZGFtIFJhZGZvcmQKK0N1cnJlbnQgVmVyc2lvbiA6IDA2
LjUwNC4wMS4wMC1yYzEKK09sZCBWZXJzaW9uICAgICA6IDAwLjAwLjA2LjE4LXJjMQorICAgIDEu
IFJlbW92ZWQgdW4tbmVlZGVkIGNvbXBsZXRpb25fbG9jayBzcGlubG9jayBjYWxscy4KKyAgICAy
LiBBZGQgbW9kdWxlIHBhcmFtIGZvciBjb25maWd1cmFibGUgTVNJLVggdmVjdG9yIGNvdW50Lgor
ICAgIDMuIExvYWQgaW9fcmVxdWVzdCBEYXRhTGVuZ3RoIGluIGJ5dGVzLgorICAgIDQuIEFkZCBh
cnJheSBib3VuZGFyeSBjaGVjayBmb3IgU3lzdGVtUEQuCisgICAgNS4gQWRkIFN5c3RlbVBEIEZh
c3RQYXRoIHN1cHBvcnQuCisgICAgNi4gUmVtb3ZlIGR1cGxpY2F0ZSBjb2RlLgorICAgIDcuIFZl
cnNpb24sIENoYW5nZWxvZywgQ29weXJpZ2h0IHVwZGF0ZS4KKy0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KIFJlbGVhc2UgRGF0ZSAgICA6IFR1ZS4gSnVuIDE3LCAyMDEyIDE3OjAwOjAwIFBTVCAyMDEy
IC0KIAkJCShlbWFpbGQtaWQ6bWVnYXJhaWRsaW51eEBsc2kuY29tKQogCQkJQWRhbSBSYWRmb3Jk
L0thc2h5YXAgRGVzYWkKZGlmZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlk
L21lZ2FyYWlkX3Nhc19iYXNlLmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzX2Jhc2UuYwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTItMTAtMDEgMTc6MTU6MTQuNDk2OTI1NTA5IC0wNzAwCisr
KyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
CTIwMTItMTAtMDEgMTc6MjE6MTUuMjg2OTU1NTY2IC0wNzAwCkBAIC0xLDcgKzEsNyBAQAogLyoK
ICAqICBMaW51eCBNZWdhUkFJRCBkcml2ZXIgZm9yIFNBUyBiYXNlZCBSQUlEIGNvbnRyb2xsZXJz
CiAgKgotICogIENvcHlyaWdodCAoYykgMjAwOS0yMDExICBMU0kgQ29ycG9yYXRpb24uCisgKiAg
Q29weXJpZ2h0IChjKSAyMDAzLTIwMTIgIExTSSBDb3Jwb3JhdGlvbi4KICAqCiAgKiAgVGhpcyBw
cm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgog
ICogIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBM
aWNlbnNlCkBAIC0xOCw3ICsxOCw3IEBACiAgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxl
IFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKICAqCiAgKiAgRklM
RTogbWVnYXJhaWRfc2FzX2Jhc2UuYwotICogIFZlcnNpb24gOiB2MDAuMDAuMDYuMTgtcmMxCisg
KiAgVmVyc2lvbiA6IHYwNi41MDQuMDEuMDAtcmMxCiAgKgogICogIEF1dGhvcnM6IExTSSBDb3Jw
b3JhdGlvbgogICogICAgICAgICAgIFNyZWVuaXZhcyBCYWdhbGtvdGUKZGlmZiAtTmF1ciBzY3Np
LW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jIHNjc2ktbWlzYy5u
ZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCi0tLSBzY3NpLW1pc2Mv
ZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCTIwMTItMDktMzAgMTY6NDc6
NDYuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfZnAuYwkyMDEyLTEwLTAxIDE3OjIyOjE0LjM2OTg2MzYwNiAtMDcwMApA
QCAtMSw3ICsxLDcgQEAKIC8qCiAgKiAgTGludXggTWVnYVJBSUQgZHJpdmVyIGZvciBTQVMgYmFz
ZWQgUkFJRCBjb250cm9sbGVycwogICoKLSAqICBDb3B5cmlnaHQgKGMpIDIwMDktMjAxMSAgTFNJ
IENvcnBvcmF0aW9uLgorICogIENvcHlyaWdodCAoYykgMjAwOS0yMDEyICBMU0kgQ29ycG9yYXRp
b24uCiAgKgogICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlz
dHJpYnV0ZSBpdCBhbmQvb3IKICAqICBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQpkaWZmIC1OYXVyIHNjc2ktbWlzYy9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjL2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMJMjAxMi0xMC0wMSAxNzoxNToxNC40
OTc5MjUwODAgLTA3MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19mdXNpb24uYwkyMDEyLTEwLTAxIDE3OjIxOjUxLjkyMjg2Mjk1NCAtMDcwMApA
QCAtMSw3ICsxLDcgQEAKIC8qCiAgKiAgTGludXggTWVnYVJBSUQgZHJpdmVyIGZvciBTQVMgYmFz
ZWQgUkFJRCBjb250cm9sbGVycwogICoKLSAqICBDb3B5cmlnaHQgKGMpIDIwMDktMjAxMSAgTFNJ
IENvcnBvcmF0aW9uLgorICogIENvcHlyaWdodCAoYykgMjAwOS0yMDEyICBMU0kgQ29ycG9yYXRp
b24uCiAgKgogICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlz
dHJpYnV0ZSBpdCBhbmQvb3IKICAqICBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQpkaWZmIC1OYXVyIHNjc2ktbWlzYy9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5oIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAotLS0gc2NzaS1taXNjL2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgJMjAxMi0wOS0zMCAxNjo0Nzo0Ni4w
MDAwMDAwMDAgLTA3MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19mdXNpb24uaAkyMDEyLTEwLTAxIDE3OjIyOjA2LjM3Njg2Mzc0MSAtMDcwMApA
QCAtMSw3ICsxLDcgQEAKIC8qCiAgKiAgTGludXggTWVnYVJBSUQgZHJpdmVyIGZvciBTQVMgYmFz
ZWQgUkFJRCBjb250cm9sbGVycwogICoKLSAqICBDb3B5cmlnaHQgKGMpIDIwMDktMjAxMSAgTFNJ
IENvcnBvcmF0aW9uLgorICogIENvcHlyaWdodCAoYykgMjAwOS0yMDEyICBMU0kgQ29ycG9yYXRp
b24uCiAgKgogICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlz
dHJpYnV0ZSBpdCBhbmQvb3IKICAqICBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBH
TlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQpkaWZmIC1OYXVyIHNjc2ktbWlzYy9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzLmgJMjAxMi0xMC0wMSAxNTo1MToxNS4yMTY5NTYyMDQgLTA3MDAKKysrIHNj
c2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTItMTAt
MDEgMTc6MjE6MzYuMjYwODYzNzgxIC0wNzAwCkBAIC0xLDcgKzEsNyBAQAogLyoKICAqICBMaW51
eCBNZWdhUkFJRCBkcml2ZXIgZm9yIFNBUyBiYXNlZCBSQUlEIGNvbnRyb2xsZXJzCiAgKgotICog
IENvcHlyaWdodCAoYykgMjAwOS0yMDExICBMU0kgQ29ycG9yYXRpb24uCisgKiAgQ29weXJpZ2h0
IChjKSAyMDAzLTIwMTIgIExTSSBDb3Jwb3JhdGlvbi4KICAqCiAgKiAgVGhpcyBwcm9ncmFtIGlz
IGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vcgogICogIG1vZGlm
eSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCkBA
IC0zMyw5ICszMyw5IEBACiAvKgogICogTWVnYVJBSUQgU0FTIERyaXZlciBtZXRhIGRhdGEKICAq
LwotI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjAwLjAwLjA2LjE4LXJjMSIKLSNkZWZpbmUg
TUVHQVNBU19SRUxEQVRFCQkJCSJKdW4uIDE3LCAyMDEyIgotI2RlZmluZSBNRUdBU0FTX0VYVF9W
RVJTSU9OCQkJIlR1ZS4gSnVuLiAxNyAxNzowMDowMCBQRFQgMjAxMiIKKyNkZWZpbmUgTUVHQVNB
U19WRVJTSU9OCQkJCSIwNi41MDQuMDEuMDAtcmMxIgorI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJ
CQkJIk9jdC4gMSwgMjAxMiIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJNb24uIE9j
dC4gMSAxNzowMDowMCBQRFQgMjAxMiIKIAogLyoKICAqIERldmljZSBJRHMK
--20cf307ca2c0d7a88d04cb0a4388--
