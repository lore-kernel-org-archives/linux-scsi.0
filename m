From: adam radford <aradford@gmail.com>
Subject: [PATCH 10/10] megaraid_sas: Changelog and version update
Date: Sat, 8 Oct 2011 18:15:24 -0700
Message-ID: <CAHtARFH8Q0Rb8-qPWh-Zk-mjZ-j1M2dwCX_+gs2BE7oZJe0bjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e6de03a4b109e404aed3685a
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBPZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:15:25 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:15:24 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e6de03a4b109e404aed3685a
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates the
ChangeLog.megaraid_sas file and updates the driver version.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc-2.6/Documentation/scsi/ChangeLog.megaraid_sas	2011-10-07
12:10:34.000000000 -0700
+++ scsi-misc-2.6.new/Documentation/scsi/ChangeLog.megaraid_sas	2011-10-08
17:26:32.763394563 -0700
@@ -1,3 +1,18 @@
+Release Date    : Wed. Oct 5, 2011 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.06.12-rc1
+Old Version     : 00.00.05.40-rc1
+    1. Continue booting immediately if FW in FAULT at driver load time.
+    2. Increase default cmds per lun to 256.
+    3. Fix mismatch in megasas_reset_fusion() mutex lock-unlock.
+    4. Remove some un-necessary code.
+    5. Clear state change interrupts for Fusion/Invader.
+    6. Clear FUSION_IN_RESET before enabling interrupts.
+    7. Add support for MegaRAID 9360/9380 12GB/s controllers.
+    8. Add multiple MSI-X vector/multiple reply queue support.
+    9. Add driver workaround for PERC5/1068 kdump kernel panic.
+-------------------------------------------------------------------------------
 Release Date    : Tue. Jul 26, 2011 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
17:21:03.762394360 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
17:24:06.595393531 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.05.40-rc1
+ *  Version : v00.00.06.12-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
17:21:03.763394208 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
17:24:41.307394681 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.05.40-rc1"
-#define MEGASAS_RELDATE				"Jul. 26, 2011"
-#define MEGASAS_EXT_VERSION			"Tue. Jul. 26 17:00:00 PDT 2011"
+#define MEGASAS_VERSION				"00.00.06.12-rc1"
+#define MEGASAS_RELDATE				"Oct. 5, 2011"
+#define MEGASAS_EXT_VERSION			"Wed. Oct. 5 17:00:00 PDT 2011"

 /*
  * Device IDs

--0016e6de03a4b109e404aed3685a
Content-Type: application/octet-stream; name="megaraid_sas.patch10"
Content-Disposition: attachment; filename="megaraid_sas.patch10"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjc7mps0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVn
YXJhaWRfc2FzIHNjc2ktbWlzYy0yLjYubmV3L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cu
bWVnYXJhaWRfc2FzCi0tLSBzY3NpLW1pc2MtMi42L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VM
b2cubWVnYXJhaWRfc2FzCTIwMTEtMTAtMDcgMTI6MTA6MzQuMDAwMDAwMDAwIC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlkX3Nh
cwkyMDExLTEwLTA4IDE3OjI2OjMyLjc2MzM5NDU2MyAtMDcwMApAQCAtMSwzICsxLDE4IEBACitS
ZWxlYXNlIERhdGUgICAgOiBXZWQuIE9jdCA1LCAyMDExIDE3OjAwOjAwIFBTVCAyMDEwIC0KKwkJ
CShlbWFpbGQtaWQ6bWVnYXJhaWRsaW51eEBsc2kuY29tKQorCQkJQWRhbSBSYWRmb3JkCitDdXJy
ZW50IFZlcnNpb24gOiAwMC4wMC4wNi4xMi1yYzEKK09sZCBWZXJzaW9uICAgICA6IDAwLjAwLjA1
LjQwLXJjMQorICAgIDEuIENvbnRpbnVlIGJvb3RpbmcgaW1tZWRpYXRlbHkgaWYgRlcgaW4gRkFV
TFQgYXQgZHJpdmVyIGxvYWQgdGltZS4KKyAgICAyLiBJbmNyZWFzZSBkZWZhdWx0IGNtZHMgcGVy
IGx1biB0byAyNTYuCisgICAgMy4gRml4IG1pc21hdGNoIGluIG1lZ2FzYXNfcmVzZXRfZnVzaW9u
KCkgbXV0ZXggbG9jay11bmxvY2suCisgICAgNC4gUmVtb3ZlIHNvbWUgdW4tbmVjZXNzYXJ5IGNv
ZGUuCisgICAgNS4gQ2xlYXIgc3RhdGUgY2hhbmdlIGludGVycnVwdHMgZm9yIEZ1c2lvbi9JbnZh
ZGVyLgorICAgIDYuIENsZWFyIEZVU0lPTl9JTl9SRVNFVCBiZWZvcmUgZW5hYmxpbmcgaW50ZXJy
dXB0cy4KKyAgICA3LiBBZGQgc3VwcG9ydCBmb3IgTWVnYVJBSUQgOTM2MC85MzgwIDEyR0IvcyBj
b250cm9sbGVycy4KKyAgICA4LiBBZGQgbXVsdGlwbGUgTVNJLVggdmVjdG9yL211bHRpcGxlIHJl
cGx5IHF1ZXVlIHN1cHBvcnQuCisgICAgOS4gQWRkIGRyaXZlciB3b3JrYXJvdW5kIGZvciBQRVJD
NS8xMDY4IGtkdW1wIGtlcm5lbCBwYW5pYy4KKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIFJlbGVh
c2UgRGF0ZSAgICA6IFR1ZS4gSnVsIDI2LCAyMDExIDE3OjAwOjAwIFBTVCAyMDEwIC0KIAkJCShl
bWFpbGQtaWQ6bWVnYXJhaWRsaW51eEBsc2kuY29tKQogCQkJQWRhbSBSYWRmb3JkCmRpZmYgLU5h
dXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jh
c2UuYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2Jhc2UuYwkyMDExLTEwLTA4IDE3OjIxOjAzLjc2MjM5NDM2MCAtMDcwMAorKysgc2NzaS1taXNj
LTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMS0x
MC0wOCAxNzoyNDowNi41OTUzOTM1MzEgLTA3MDAKQEAgLTE4LDcgKzE4LDcgQEAKICAqICBGb3Vu
ZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAwMjEx
MS0xMzA3IFVTQQogICoKICAqICBGSUxFOiBtZWdhcmFpZF9zYXNfYmFzZS5jCi0gKiAgVmVyc2lv
biA6IHYwMC4wMC4wNS40MC1yYzEKKyAqICBWZXJzaW9uIDogdjAwLjAwLjA2LjEyLXJjMQogICoK
ICAqICBBdXRob3JzOiBMU0kgQ29ycG9yYXRpb24KICAqICAgICAgICAgICBTcmVlbml2YXMgQmFn
YWxrb3RlCmRpZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzLmggc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2Fy
YWlkX3Nhcy5oCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaAkyMDExLTEwLTA4IDE3OjIxOjAzLjc2MzM5NDIwOCAtMDcwMAorKysgc2NzaS1taXNj
LTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTEtMTAtMDgg
MTc6MjQ6NDEuMzA3Mzk0NjgxIC0wNzAwCkBAIC0zMyw5ICszMyw5IEBACiAvKgogICogTWVnYVJB
SUQgU0FTIERyaXZlciBtZXRhIGRhdGEKICAqLwotI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJ
IjAwLjAwLjA1LjQwLXJjMSIKLSNkZWZpbmUgTUVHQVNBU19SRUxEQVRFCQkJCSJKdWwuIDI2LCAy
MDExIgotI2RlZmluZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkJIlR1ZS4gSnVsLiAyNiAxNzowMDow
MCBQRFQgMjAxMSIKKyNkZWZpbmUgTUVHQVNBU19WRVJTSU9OCQkJCSIwMC4wMC4wNi4xMi1yYzEi
CisjZGVmaW5lIE1FR0FTQVNfUkVMREFURQkJCQkiT2N0LiA1LCAyMDExIgorI2RlZmluZSBNRUdB
U0FTX0VYVF9WRVJTSU9OCQkJIldlZC4gT2N0LiA1IDE3OjAwOjAwIFBEVCAyMDExIgogCiAvKgog
ICogRGV2aWNlIElEcwo=
--0016e6de03a4b109e404aed3685a--
