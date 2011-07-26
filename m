From: adam radford <aradford@gmail.com>
Subject: [PATCH 3/3] megaraid_sas Version and Changelog update
Date: Tue, 26 Jul 2011 15:43:01 -0700
Message-ID: <CAHtARFGJe_=O8so8gYOcMbovhmPesjw6NKrZ=oH0Q=yRQ-WGeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=000e0cd56b4474256104a900a74f
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44068 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab1GZWnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2011 18:43:01 -0400
Received: by mail-iy0-f174.google.com with SMTP id 12so982773iyb.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2011 15:43:01 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--000e0cd56b4474256104a900a74f
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas updates version to 5.40-rc1, and
updates ChangeLog.megaraid_sas

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc/Documentation/scsi/ChangeLog.megaraid_sas
scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas
--- scsi-misc/Documentation/scsi/ChangeLog.megaraid_sas	2011-07-21
19:17:23.000000000 -0700
+++ scsi-misc.new/Documentation/scsi/ChangeLog.megaraid_sas	2011-07-26
14:24:38.398279313 -0700
@@ -1,3 +1,11 @@
+Release Date    : Tue. Jul 26, 2011 17:00:00 PST 2010 -
+			(emaild-id:megaraidlinux@lsi.com)
+			Adam Radford
+Current Version : 00.00.05.40-rc1
+Old Version     : 00.00.05.38-rc1
+    1. Fix FastPath I/O to work with degraded RAID 1.
+    2. Add .change_queue_depth support.
+-------------------------------------------------------------------------------
 Release Date    : Wed. May 11, 2011 17:00:00 PST 2010 -
 			(emaild-id:megaraidlinux@lsi.com)
 			Adam Radford
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas_base.c	2011-07-26
14:20:45.651371717 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-07-26
14:22:25.292401848 -0700
@@ -18,7 +18,7 @@
  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
  *  FILE: megaraid_sas_base.c
- *  Version : v00.00.05.38-rc1
+ *  Version : v00.00.05.40-rc1
  *
  *  Authors: LSI Corporation
  *           Sreenivas Bagalkote
diff -Naur scsi-misc/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc/drivers/scsi/megaraid/megaraid_sas.h	2011-07-21
19:17:23.000000000 -0700
+++ scsi-misc.new/drivers/scsi/megaraid/megaraid_sas.h	2011-07-26
14:22:48.810278854 -0700
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION				"00.00.05.38-rc1"
-#define MEGASAS_RELDATE				"May. 11, 2011"
-#define MEGASAS_EXT_VERSION			"Wed. May. 11 17:00:00 PDT 2011"
+#define MEGASAS_VERSION				"00.00.05.40-rc1"
+#define MEGASAS_RELDATE				"Jul. 26, 2011"
+#define MEGASAS_EXT_VERSION			"Tue. Jul. 26 17:00:00 PDT 2011"

 /*
  * Device IDs

--000e0cd56b4474256104a900a74f
Content-Type: application/octet-stream; name="megaraid_sas.patch3"
Content-Disposition: attachment; filename="megaraid_sas.patch3"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gqlellra0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MvRG9jdW1lbnRhdGlvbi9zY3NpL0NoYW5nZUxvZy5tZWdhcmFp
ZF9zYXMgc2NzaS1taXNjLm5ldy9Eb2N1bWVudGF0aW9uL3Njc2kvQ2hhbmdlTG9nLm1lZ2FyYWlk
X3NhcwotLS0gc2NzaS1taXNjL0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRf
c2FzCTIwMTEtMDctMjEgMTk6MTc6MjMuMDAwMDAwMDAwIC0wNzAwCisrKyBzY3NpLW1pc2MubmV3
L0RvY3VtZW50YXRpb24vc2NzaS9DaGFuZ2VMb2cubWVnYXJhaWRfc2FzCTIwMTEtMDctMjYgMTQ6
MjQ6MzguMzk4Mjc5MzEzIC0wNzAwCkBAIC0xLDMgKzEsMTEgQEAKK1JlbGVhc2UgRGF0ZSAgICA6
IFR1ZS4gSnVsIDI2LCAyMDExIDE3OjAwOjAwIFBTVCAyMDEwIC0KKwkJCShlbWFpbGQtaWQ6bWVn
YXJhaWRsaW51eEBsc2kuY29tKQorCQkJQWRhbSBSYWRmb3JkCitDdXJyZW50IFZlcnNpb24gOiAw
MC4wMC4wNS40MC1yYzEKK09sZCBWZXJzaW9uICAgICA6IDAwLjAwLjA1LjM4LXJjMQorICAgIDEu
IEZpeCBGYXN0UGF0aCBJL08gdG8gd29yayB3aXRoIGRlZ3JhZGVkIFJBSUQgMS4KKyAgICAyLiBB
ZGQgLmNoYW5nZV9xdWV1ZV9kZXB0aCBzdXBwb3J0LgorLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQog
UmVsZWFzZSBEYXRlICAgIDogV2VkLiBNYXkgMTEsIDIwMTEgMTc6MDA6MDAgUFNUIDIwMTAgLQog
CQkJKGVtYWlsZC1pZDptZWdhcmFpZGxpbnV4QGxzaS5jb20pCiAJCQlBZGFtIFJhZGZvcmQKZGlm
ZiAtTmF1ciBzY3NpLW1pc2MvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNl
LmMgc2NzaS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwotLS0gc2NzaS1taXNjL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5j
CTIwMTEtMDctMjYgMTQ6MjA6NDUuNjUxMzcxNzE3IC0wNzAwCisrKyBzY3NpLW1pc2MubmV3L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTEtMDctMjYgMTQ6MjI6
MjUuMjkyNDAxODQ4IC0wNzAwCkBAIC0xOCw3ICsxOCw3IEBACiAgKiAgRm91bmRhdGlvbiwgSW5j
LiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EK
ICAqCiAgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Jhc2UuYwotICogIFZlcnNpb24gOiB2MDAuMDAu
MDUuMzgtcmMxCisgKiAgVmVyc2lvbiA6IHYwMC4wMC4wNS40MC1yYzEKICAqCiAgKiAgQXV0aG9y
czogTFNJIENvcnBvcmF0aW9uCiAgKiAgICAgICAgICAgU3JlZW5pdmFzIEJhZ2Fsa290ZQpkaWZm
IC1OYXVyIHNjc2ktbWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggc2Nz
aS1taXNjLm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgKLS0tIHNjc2kt
bWlzYy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0wNy0yMSAxOTox
NzoyMy4wMDAwMDAwMDAgLTA3MDAKKysrIHNjc2ktbWlzYy5uZXcvZHJpdmVycy9zY3NpL21lZ2Fy
YWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTEtMDctMjYgMTQ6MjI6NDguODEwMjc4ODU0IC0wNzAwCkBA
IC0zMyw5ICszMyw5IEBACiAvKgogICogTWVnYVJBSUQgU0FTIERyaXZlciBtZXRhIGRhdGEKICAq
LwotI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQkJIjAwLjAwLjA1LjM4LXJjMSIKLSNkZWZpbmUg
TUVHQVNBU19SRUxEQVRFCQkJCSJNYXkuIDExLCAyMDExIgotI2RlZmluZSBNRUdBU0FTX0VYVF9W
RVJTSU9OCQkJIldlZC4gTWF5LiAxMSAxNzowMDowMCBQRFQgMjAxMSIKKyNkZWZpbmUgTUVHQVNB
U19WRVJTSU9OCQkJCSIwMC4wMC4wNS40MC1yYzEiCisjZGVmaW5lIE1FR0FTQVNfUkVMREFURQkJ
CQkiSnVsLiAyNiwgMjAxMSIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJUdWUuIEp1
bC4gMjYgMTc6MDA6MDAgUERUIDIwMTEiCiAKIC8qCiAgKiBEZXZpY2UgSURzCg==
--000e0cd56b4474256104a900a74f--
