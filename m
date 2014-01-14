From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 2/2] scsi: hpsa, remove cancelled ID's and add a new one
Date: Tue, 14 Jan 2014 11:01:15 -0600
Message-ID: <20140114170115.GB12564@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0014.houston.hp.com ([15.201.24.17]:42008 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaANRBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jan 2014 12:01:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>

From: Mike Miller <mike.miller@hp.com>

3 controllers have been cancelled and one new has been added. Please consider
this for inclusion.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 8a27d7b..348b207 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -112,15 +112,13 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BE},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BF},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C0},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C1},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C2},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CB},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
@@ -162,15 +160,13 @@ static struct board_type products[] = {
 	{0x21BE103C, "Smart Array", &SA5_access},
 	{0x21BF103C, "Smart Array", &SA5_access},
 	{0x21C0103C, "Smart Array", &SA5_access},
-	{0x21C1103C, "Smart Array", &SA5_access},
 	{0x21C2103C, "Smart Array", &SA5_access},
 	{0x21C3103C, "Smart Array", &SA5_access},
-	{0x21C4103C, "Smart Array", &SA5_access},
 	{0x21C5103C, "Smart Array", &SA5_access},
 	{0x21C7103C, "Smart Array", &SA5_access},
 	{0x21C8103C, "Smart Array", &SA5_access},
-	{0x21C9103C, "Smart Array", &SA5_access},
 	{0x21CA103C, "Smart Array", &SA5_access},
+	{0x21CB103C, "Smart Array", &SA5_access},
 	{0x21CC103C, "Smart Array", &SA5_access},
 	{0x21CD103C, "Smart Array", &SA5_access},
 	{0x21CE103C, "Smart Array", &SA5_access},
