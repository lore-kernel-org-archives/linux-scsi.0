From: adam radford <aradford@gmail.com>
Subject: [PATCH] 3ware maintainers update
Date: Mon, 8 Mar 2010 12:40:36 -0800
Message-ID: <b1bc6a001003081240i43fc2bccg198bab6cf8288a9f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=001636ed734ece2a480481501376
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34049 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab0CHUkh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 15:40:37 -0500
Received: by gwb15 with SMTP id 15so3162779gwb.19
        for <linux-scsi@vger.kernel.org>; Mon, 08 Mar 2010 12:40:36 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

--001636ed734ece2a480481501376
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

This patch updates the 3ware maintainers in the MAINTAINERS file.

Signed-off-by: Adam Radford <aradford@gmail.com>

-Adam

Note: This patch is included in-line below and also as an attachment.

diff -Naur linux-2.6.33-git15/MAINTAINERS linux-2.6.33-git16/MAINTAINERS
--- linux-2.6.33-git15/MAINTAINERS	2010-03-08 11:32:05.000000000 -0800
+++ linux-2.6.33-git16/MAINTAINERS	2010-03-08 11:39:11.000000000 -0800
@@ -131,19 +131,12 @@
 S:	Maintained
 F:	drivers/net/typhoon*

-3W-9XXX SATA-RAID CONTROLLER DRIVER
-M:	Adam Radford <linuxraid@amcc.com>
+3WARE SAS/SATA-RAID SCSI DRIVERS (3W-XXXX, 3W-9XXX, 3W-SAS)
+M:	Adam Radford <linuxraid@lsi.com>
 L:	linux-scsi@vger.kernel.org
-W:	http://www.amcc.com
+W:	http://www.lsi.com
 S:	Supported
-F:	drivers/scsi/3w-9xxx*
-
-3W-XXXX ATA-RAID CONTROLLER DRIVER
-M:	Adam Radford <linuxraid@amcc.com>
-L:	linux-scsi@vger.kernel.org
-W:	http://www.amcc.com
-S:	Supported
-F:	drivers/scsi/3w-xxxx*
+F:	drivers/scsi/3w-*

 53C700 AND 53C700-66 SCSI DRIVER
 M:	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>

--001636ed734ece2a480481501376
Content-Type: text/x-patch; charset=US-ASCII; name="3ware_maintainers.patch"
Content-Disposition: attachment; filename="3ware_maintainers.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g6jqkic80

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzMtZ2l0MTUvTUFJTlRBSU5FUlMgbGludXgtMi42LjMzLWdp
dDE2L01BSU5UQUlORVJTCi0tLSBsaW51eC0yLjYuMzMtZ2l0MTUvTUFJTlRBSU5FUlMJMjAxMC0w
My0wOCAxMTozMjowNS4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zMy1naXQxNi9NQUlO
VEFJTkVSUwkyMDEwLTAzLTA4IDExOjM5OjExLjAwMDAwMDAwMCAtMDgwMApAQCAtMTMxLDE5ICsx
MzEsMTIgQEAKIFM6CU1haW50YWluZWQKIEY6CWRyaXZlcnMvbmV0L3R5cGhvb24qCiAKLTNXLTlY
WFggU0FUQS1SQUlEIENPTlRST0xMRVIgRFJJVkVSCi1NOglBZGFtIFJhZGZvcmQgPGxpbnV4cmFp
ZEBhbWNjLmNvbT4KKzNXQVJFIFNBUy9TQVRBLVJBSUQgU0NTSSBEUklWRVJTICgzVy1YWFhYLCAz
Vy05WFhYLCAzVy1TQVMpCitNOglBZGFtIFJhZGZvcmQgPGxpbnV4cmFpZEBsc2kuY29tPgogTDoJ
bGludXgtc2NzaUB2Z2VyLmtlcm5lbC5vcmcKLVc6CWh0dHA6Ly93d3cuYW1jYy5jb20KK1c6CWh0
dHA6Ly93d3cubHNpLmNvbQogUzoJU3VwcG9ydGVkCi1GOglkcml2ZXJzL3Njc2kvM3ctOXh4eCoK
LQotM1ctWFhYWCBBVEEtUkFJRCBDT05UUk9MTEVSIERSSVZFUgotTToJQWRhbSBSYWRmb3JkIDxs
aW51eHJhaWRAYW1jYy5jb20+Ci1MOglsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZwotVzoJaHR0
cDovL3d3dy5hbWNjLmNvbQotUzoJU3VwcG9ydGVkCi1GOglkcml2ZXJzL3Njc2kvM3cteHh4eCoK
K0Y6CWRyaXZlcnMvc2NzaS8zdy0qCiAKIDUzQzcwMCBBTkQgNTNDNzAwLTY2IFNDU0kgRFJJVkVS
CiBNOgkiSmFtZXMgRS5KLiBCb3R0b21sZXkiIDxKYW1lcy5Cb3R0b21sZXlASGFuc2VuUGFydG5l
cnNoaXAuY29tPgo=
--001636ed734ece2a480481501376--
