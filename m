From: Joe Handzik <joseph.t.handzik@beardog.cce.hp.com>
Subject: [PATCH] hpsa: add new PCI IDs (March 2014)
Date: Tue, 25 Mar 2014 16:13:49 -0500
Message-ID: <20140325211246.2849.88104.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:46750 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbaCYVOv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Mar 2014 17:14:51 -0400
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 5340E60A73
	for <linux-scsi@vger.kernel.org>; Tue, 25 Mar 2014 21:14:51 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, joseph.t.handzik@hp.com, thomas.henzl@redhat.com, scott.teel@hp.com, scameron@beardog.cce.hp.com

From: Joe Handzik <joseph.t.handzik@hp.com>

Adding in six PCI IDs for unreleased controllers that slipped through the cracks in previous patch submissions.

Signed-off-by: Scott Teel <scott.teel@hp.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
---
 drivers/scsi/hpsa.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8cf4a0c..7bbcc92 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -115,9 +115,15 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C6},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CB},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
@@ -165,9 +171,15 @@ static struct board_type products[] = {
 	{0x21C3103C, "Smart Array", &SA5_access},
 	{0x21C4103C, "Smart Array", &SA5_access},
 	{0x21C5103C, "Smart Array", &SA5_access},
+	{0x21C6103C, "Smart Array", &SA5_access},
 	{0x21C7103C, "Smart Array", &SA5_access},
 	{0x21C8103C, "Smart Array", &SA5_access},
 	{0x21C9103C, "Smart Array", &SA5_access},
+	{0x21CA103C, "Smart Array", &SA5_access},
+	{0x21CB103C, "Smart Array", &SA5_access},
+	{0x21CC103C, "Smart Array", &SA5_access},
+	{0x21CD103C, "Smart Array", &SA5_access},
+	{0x21CE103C, "Smart Array", &SA5_access},
 	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
 	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
 	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},

