From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/3] megaraid_sas: Version and Changelog update
Date: Sat, 9 Feb 2013 15:29:25 -0800
Message-ID: <CAHtARFE4LJh4+_iw=prtcc8o7KyzspCx60iWbhdZm0Cip_YpJQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf3074b7a6e2185504d5530bf3
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qe0-f52.google.com ([209.85.128.52]:63241 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576Ab3BIX30 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Feb 2013 18:29:26 -0500
Received: by mail-qe0-f52.google.com with SMTP id 6so2123199qeb.25
        for <linux-scsi@vger.kernel.org>; Sat, 09 Feb 2013 15:29:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kashyap Desai <Kashyap.Desai@lsi.com>

--20cf3074b7a6e2185504d5530bf3
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch updates the megaraid_sas driver version and updates
Documentation/scsi/ChangeLog.megaraid_sas.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc.old/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc.old/Documentation/scsi/ChangeLog.megaraid_sas	2013-02-08
13:20:39.000000000 -0800
+++ scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas	2013-02-09
22:51:59.079867393 -0800
@@ -1,3 +1,12 @@
+Release Date    : Sat. Feb 9, 2013 17:00:00 PST 2013 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 06.506.00.00-rc1
+Old Version     : 06.504.01.00-rc1
+    1. Add 4k FastPath DIF support.
+    2. Dont load DevHandle unless FastPath enabled.
+    3. Version and Changelog update.
+-------------------------------------------------------------------------------
 Release Date    : Mon. Oct 1, 2012 17:00:00 PST 2012 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas_base.c	2013-02-08
13:20:39.000000000 -0800
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2013-02-09
22:52:28.607810580 -0800
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v06.504.01.00-rc1
+ *  Version : v06.506.00.00-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc.old/drivers/scsi/megaraid/megaraid_sas.h	2013-02-08
13:20:39.000000000 -0800
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h	2013-02-09
22:52:53.344866438 -0800
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"06.504.01.00-rc1"
-#define MEGASAS_RELDATE				"Oct. 1, 2012"
-#define MEGASAS_EXT_VERSION			"Mon. Oct. 1 17:00:00 PDT 2012"
+#define MEGASAS_VERSION				"06.506.00.00-rc1"
+#define MEGASAS_RELDATE				"Feb. 9, 2013"
+#define MEGASAS_EXT_VERSION			"Sat. Feb. 9 17:00:00 PDT 2013"

 /*
  * Device IDs

--20cf3074b7a6e2185504d5530bf3
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hcze7yby0

ZGlmZiAtTmF1ciBzY3NpLW1pc2Mub2xkL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy5uZXcvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdh
cmFpZF9zYXMKLS0tIHNjc2ktbWlzYy5vbGQvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5t
ZWdhcmFpZF9zYXMJMjAxMy0wMi0wOCAxMzoyMDozOS4wMDAwMDAwMDAgLTA4MDAKKysrIHNjc2kt
bWlzYy5uZXcvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFpZF9zYXMJMjAxMy0w
Mi0wOSAyMjo1MTo1OS4wNzk4NjczOTMgLTA4MDAKQEAgLTEsMyArMSwxMiBAQAorUmVsZWFzZSBE
YXRlICAgIDogU2F0LiBGZWIgOSwgMjAxMyAxNzowMDowMCBQU1QgMjAxMyAtCisJCQkoZW1haWxk
LWlkOm1lZ2FyYWlkbGludXhAbHNpLmNvbSkKKwkJCUFkYW0gUmFkZm9yZAorQ3VycmVudCBWZXJz
aW9uIDogMDYuNTA2LjAwLjAwLXJjMQorT2xkIFZlcnNpb24gICAgIDogMDYuNTA0LjAxLjAwLXJj
MQorICAgIDEuIEFkZCA0ayBGYXN0UGF0aCBESUYgc3VwcG9ydC4KKyAgICAyLiBEb250IGxvYWQg
RGV2SGFuZGxlIHVubGVzcyBGYXN0UGF0aCBlbmFibGVkLgorICAgIDMuIFZlcnNpb24gYW5kIENo
YW5nZWxvZyB1cGRhdGUuCistLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiBSZWxlYXNlIERhdGUgICAg
OiBNb24uIE9jdCAxLCAyMDEyIDE3OjAwOjAwIFBTVCAyMDEyIC0KIAkJCShlbWFpbGQtaWQ6bWVn
YXJhaWRsaW51eEBsc2kuY29tKQogCQkJQWRhbSBSYWRmb3JkCmRpZmYgLU5hdXIgc2NzaS1taXNj
Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYyBzY3NpLW1pc2Mu
bmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1p
c2Mub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTMtMDIt
MDggMTM6MjA6MzkuMDAwMDAwMDAwIC0wODAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTMtMDItMDkgMjI6NTI6MjguNjA3ODEw
NTgwIC0wODAwCkBAIC0xOCw3ICsxOCw3IEBACiAgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVt
cGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKICAqCiAgKiAg
RklMRTogbWVnYXJhaWRfc2FzX2Jhc2UuYwotICogIFZlcnNpb24gOiB2MDYuNTA0LjAxLjAwLXJj
MQorICogIFZlcnNpb24gOiB2MDYuNTA2LjAwLjAwLXJjMQogICoKICAqICBBdXRob3JzOiBMU0kg
Q29ycG9yYXRpb24KICAqICAgICAgICAgICBTcmVlbml2YXMgQmFnYWxrb3RlCmRpZmYgLU5hdXIg
c2NzaS1taXNjLm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggc2NzaS1t
aXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2ktbWlz
Yy5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTMtMDItMDggMTM6
MjA6MzkuMDAwMDAwMDAwIC0wODAwCisrKyBzY3NpLW1pc2MubmV3L2RyaXZlcnMvc2NzaS9tZWdh
cmFpZC9tZWdhcmFpZF9zYXMuaAkyMDEzLTAyLTA5IDIyOjUyOjUzLjM0NDg2NjQzOCAtMDgwMApA
QCAtMzMsOSArMzMsOSBAQAogLyoKICAqIE1lZ2FSQUlEIFNBUyBEcml2ZXIgbWV0YSBkYXRhCiAg
Ki8KLSNkZWZpbmUgTUVHQVNBU19WRVJTSU9OCQkJCSIwNi41MDQuMDEuMDAtcmMxIgotI2RlZmlu
ZSBNRUdBU0FTX1JFTERBVEUJCQkJIk9jdC4gMSwgMjAxMiIKLSNkZWZpbmUgTUVHQVNBU19FWFRf
VkVSU0lPTgkJCSJNb24uIE9jdC4gMSAxNzowMDowMCBQRFQgMjAxMiIKKyNkZWZpbmUgTUVHQVNB
U19WRVJTSU9OCQkJCSIwNi41MDYuMDAuMDAtcmMxIgorI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJ
CQkJIkZlYi4gOSwgMjAxMyIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJTYXQuIEZl
Yi4gOSAxNzowMDowMCBQRFQgMjAxMyIKIAogLyoKICAqIERldmljZSBJRHMK
--20cf3074b7a6e2185504d5530bf3--
