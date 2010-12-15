From: adam radford <aradford@gmail.com>
Subject: [PATCH 2/11]: megaraid_sas: Update GPL headers.
Date: Tue, 14 Dec 2010 18:51:48 -0800
Message-ID: <AANLkTi=Rx1dK07nisQACkf-ECyS_umUCpB=zDaArmAc7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636831cdac0047504976a04d7
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34585 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758698Ab0LOCvt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 21:51:49 -0500
Received: by qwa26 with SMTP id 26so1481525qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 18:51:48 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--001636831cdac0047504976a04d7
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch updates the GPL headers in megaraid_sas_base.c and megaraid_sas.h.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: This patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-14
15:53:14.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-14
16:01:00.000000000 -0800
@@ -1,27 +1,34 @@
 /*
+ *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *		Linux MegaRAID driver for SAS based RAID controllers
+ *  Copyright (c) 2009-2011  LSI Corporation.
  *
- * Copyright (c) 2003-2005  LSI Corporation.
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
  *
- *	   This program is free software; you can redistribute it and/or
- *	   modify it under the terms of the GNU General Public License
- *	   as published by the Free Software Foundation; either version
- *	   2 of the License, or (at your option) any later version.
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  *
- * FILE		: megaraid_sas.c
- * Version     : v00.00.04.31-rc1
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  *
- * Authors:
- *	(email-id : megaraidlinux@lsi.com)
- * 	Sreenivas Bagalkote
- * 	Sumant Patro
- *	Bo Yang
+ *  FILE: megaraid_sas_base.c
+ *  Version : v00.00.05.29-rc1
  *
- * List of supported controllers
+ *  Authors: LSI Corporation
+ *           Sreenivas Bagalkote
+ *           Sumant Patro
+ *           Bo Yang
  *
- * OEM	Product Name			VID	DID	SSVID	SSID
- * ---	------------			---	---	----	----
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
  */

 #include <linux/kernel.h>
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h	2010-12-06
20:09:04.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2010-12-14
15:55:13.000000000 -0800
@@ -1,15 +1,30 @@
 /*
+ *  Linux MegaRAID driver for SAS based RAID controllers
  *
- *		Linux MegaRAID driver for SAS based RAID controllers
+ *  Copyright (c) 2009-2011  LSI Corporation.
  *
- * Copyright (c) 2003-2005  LSI Corporation.
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
  *
- *		This program is free software; you can redistribute it and/or
- *		modify it under the terms of the GNU General Public License
- *		as published by the Free Software Foundation; either version
- *		2 of the License, or (at your option) any later version.
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
  *
- * FILE		: megaraid_sas.h
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas.h
+ *
+ *  Authors: LSI Corporation
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
  */

 #ifndef LSI_MEGARAID_SAS_H

--001636831cdac0047504976a04d7
Content-Type: application/octet-stream; name="megaraid_sas.patch2"
Content-Disposition: attachment; filename="megaraid_sas.patch2"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpmfnr20

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0xNCAxNTo1MzoxNC4wMDAw
MDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTAtMTItMTQgMTY6MDE6MDAuMDAwMDAwMDAwIC0wODAw
CkBAIC0xLDI3ICsxLDM0IEBACiAvKgorICogIExpbnV4IE1lZ2FSQUlEIGRyaXZlciBmb3IgU0FT
IGJhc2VkIFJBSUQgY29udHJvbGxlcnMKICAqCi0gKgkJTGludXggTWVnYVJBSUQgZHJpdmVyIGZv
ciBTQVMgYmFzZWQgUkFJRCBjb250cm9sbGVycworICogIENvcHlyaWdodCAoYykgMjAwOS0yMDEx
ICBMU0kgQ29ycG9yYXRpb24uCiAgKgotICogQ29weXJpZ2h0IChjKSAyMDAzLTIwMDUgIExTSSBD
b3Jwb3JhdGlvbi4KKyAqICBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiBy
ZWRpc3RyaWJ1dGUgaXQgYW5kL29yCisgKiAgbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0
aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAqICBhcyBwdWJsaXNoZWQgYnkgdGhlIEZy
ZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMgorICogIG9mIHRoZSBMaWNl
bnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgogICoKLSAqCSAgIFRo
aXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQv
b3IKLSAqCSAgIG1vZGlmeSBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1
YmxpYyBMaWNlbnNlCi0gKgkgICBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91
bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24KLSAqCSAgIDIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5
b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisgKiAgVGhpcyBwcm9ncmFtIGlzIGRpc3Ry
aWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsCisgKiAgYnV0IFdJVEhP
VVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAq
ICBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBT
ZWUgdGhlCisgKiAgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4K
ICAqCi0gKiBGSUxFCQk6IG1lZ2FyYWlkX3Nhcy5jCi0gKiBWZXJzaW9uICAgICA6IHYwMC4wMC4w
NC4zMS1yYzEKKyAqICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICogIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBu
b3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlCisgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkg
VGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKICAqCi0g
KiBBdXRob3JzOgotICoJKGVtYWlsLWlkIDogbWVnYXJhaWRsaW51eEBsc2kuY29tKQotICogCVNy
ZWVuaXZhcyBCYWdhbGtvdGUKLSAqIAlTdW1hbnQgUGF0cm8KLSAqCUJvIFlhbmcKKyAqICBGSUxF
OiBtZWdhcmFpZF9zYXNfYmFzZS5jCisgKiAgVmVyc2lvbiA6IHYwMC4wMC4wNS4yOS1yYzEKICAq
Ci0gKiBMaXN0IG9mIHN1cHBvcnRlZCBjb250cm9sbGVycworICogIEF1dGhvcnM6IExTSSBDb3Jw
b3JhdGlvbgorICogICAgICAgICAgIFNyZWVuaXZhcyBCYWdhbGtvdGUKKyAqICAgICAgICAgICBT
dW1hbnQgUGF0cm8KKyAqICAgICAgICAgICBCbyBZYW5nCiAgKgotICogT0VNCVByb2R1Y3QgTmFt
ZQkJCVZJRAlESUQJU1NWSUQJU1NJRAotICogLS0tCS0tLS0tLS0tLS0tLQkJCS0tLQktLS0JLS0t
LQktLS0tCisgKiAgU2VuZCBmZWVkYmFjayB0bzogPG1lZ2FyYWlkbGludXhAbHNpLmNvbT4KKyAq
CisgKiAgTWFpbCB0bzogTFNJIENvcnBvcmF0aW9uLCAxNjIxIEJhcmJlciBMYW5lLCBNaWxwaXRh
cywgQ0EgOTUwMzUKKyAqICAgICBBVFROOiBMaW51eHJhaWQKICAqLwogCiAjaW5jbHVkZSA8bGlu
dXgva2VybmVsLmg+CmRpZmYgLU5hdXIgbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTAtMTItMDYgMjA6MDk6MDQuMDAwMDAw
MDAwIC0wODAwCisrKyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQv
bWVnYXJhaWRfc2FzLmgJMjAxMC0xMi0xNCAxNTo1NToxMy4wMDAwMDAwMDAgLTA4MDAKQEAgLTEs
MTUgKzEsMzAgQEAKIC8qCisgKiAgTGludXggTWVnYVJBSUQgZHJpdmVyIGZvciBTQVMgYmFzZWQg
UkFJRCBjb250cm9sbGVycwogICoKLSAqCQlMaW51eCBNZWdhUkFJRCBkcml2ZXIgZm9yIFNBUyBi
YXNlZCBSQUlEIGNvbnRyb2xsZXJzCisgKiAgQ29weXJpZ2h0IChjKSAyMDA5LTIwMTEgIExTSSBD
b3Jwb3JhdGlvbi4KICAqCi0gKiBDb3B5cmlnaHQgKGMpIDIwMDMtMjAwNSAgTFNJIENvcnBvcmF0
aW9uLgorICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJp
YnV0ZSBpdCBhbmQvb3IKKyAqICBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUg
R2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICogIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0
d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lvbiAyCisgKiAgb2YgdGhlIExpY2Vuc2UsIG9y
IChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZlcnNpb24uCiAgKgotICoJCVRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IKLSAqCQlt
b2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5z
ZQotICoJCWFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRo
ZXIgdmVyc2lvbgotICoJCTIgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55
IGxhdGVyIHZlcnNpb24uCisgKiAgVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBo
b3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsCisgKiAgYnV0IFdJVEhPVVQgQU5ZIFdBUlJBTlRZ
OyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQgd2FycmFudHkgb2YKKyAqICBNRVJDSEFOVEFCSUxJ
VFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNVTEFSIFBVUlBPU0UuICBTZWUgdGhlCisgKiAgR05V
IEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KICAqCi0gKiBGSUxFCQk6
IG1lZ2FyYWlkX3Nhcy5oCisgKiAgWW91IHNob3VsZCBoYXZlIHJlY2VpdmVkIGEgY29weSBvZiB0
aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAqICBhbG9uZyB3aXRoIHRoaXMgcHJvZ3Jh
bTsgaWYgbm90LCB3cml0ZSB0byB0aGUgRnJlZSBTb2Z0d2FyZQorICogIEZvdW5kYXRpb24sIElu
Yy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBCb3N0b24sIE1BIDAyMTExLTEzMDcgVVNB
CisgKgorICogIEZJTEU6IG1lZ2FyYWlkX3Nhcy5oCisgKgorICogIEF1dGhvcnM6IExTSSBDb3Jw
b3JhdGlvbgorICoKKyAqICBTZW5kIGZlZWRiYWNrIHRvOiA8bWVnYXJhaWRsaW51eEBsc2kuY29t
PgorICoKKyAqICBNYWlsIHRvOiBMU0kgQ29ycG9yYXRpb24sIDE2MjEgQmFyYmVyIExhbmUsIE1p
bHBpdGFzLCBDQSA5NTAzNQorICogICAgIEFUVE46IExpbnV4cmFpZAogICovCiAKICNpZm5kZWYg
TFNJX01FR0FSQUlEX1NBU19ICg==
--001636831cdac0047504976a04d7--
