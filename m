From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 34/35] hpsa: Add support for a few HP Storage controllers
Date: Tue, 18 Feb 2014 13:58:02 -0600
Message-ID: <20140218195802.15787.73000.stgit@beardog.cce.hp.com>
References: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:43874 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaBRT7f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2014 14:59:35 -0500
Received: from g4t3427.houston.hp.com (g4t3427.houston.hp.com [15.201.208.55])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id B12BB60EE8
	for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2014 19:59:35 +0000 (UTC)
In-Reply-To: <20140218195251.15787.55872.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dab@hp.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, scott.teel@hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9410482..c8de330 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -119,6 +119,11 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
+	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
+	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
+	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
+	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0088},
+	{PCI_VENDOR_ID_HP, 0x333f, 0x103c, 0x333f},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -164,6 +169,11 @@ static struct board_type products[] = {
 	{0x21C7103C, "Smart Array", &SA5_access},
 	{0x21C8103C, "Smart Array", &SA5_access},
 	{0x21C9103C, "Smart Array", &SA5_access},
+	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
+	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
+	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},
+	{0x00881590, "HP Storage P1228e Array Controller", &SA5_access},
+	{0x333f103c, "HP StorageWorks 1210m Array Controller", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 

