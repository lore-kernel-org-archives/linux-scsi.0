From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 1/2] hpsa: add 4 new PCI ID's for HP Gen9 servers
Date: Wed, 11 Dec 2013 12:44:13 -0600
Message-ID: <20131211184413.GA11427@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0027.austin.hp.com ([15.216.28.34]:42065 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LKSoP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2013 13:44:15 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com

From: Mike Miller <mike.miller@hp.com>

This patch adds 4 more PCI ID's for HP Gen9 servers. These new ID's were
just made known this week.

Signed-off-by: Mike Miller <mike.miller@hp.com>
---
 drivers/scsi/hpsa.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 67112a8..4af97d6 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -117,6 +117,10 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
+	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
 	{PCI_VENDOR_ID_HP,     PCI_ANY_ID,	PCI_ANY_ID, PCI_ANY_ID,
 		PCI_CLASS_STORAGE_RAID << 8, 0xffff << 8, 0},
 	{0,}
@@ -162,6 +166,10 @@ static struct board_type products[] = {
 	{0x21C7103C, "Smart Array", &SA5_access},
 	{0x21C8103C, "Smart Array", &SA5_access},
 	{0x21C9103C, "Smart Array", &SA5_access},
+	{0x21CA103C, "Smart Array", &SA5_access},
+	{0x21CC103C, "Smart Array", &SA5_access},
+	{0x21CD103C, "Smart Array", &SA5_access},
+	{0x21CE103C, "Smart Array", &SA5_access},
 	{0xFFFF103C, "Unknown Smart Array", &SA5_access},
 };
 
