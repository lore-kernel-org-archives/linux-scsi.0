From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 43/43] hpsa: add in new controller id
Date: Thu, 16 Apr 2015 08:50:37 -0500
Message-ID: <20150416135037.30238.63728.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:46245 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968AbbDPNvi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:51:38 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

add in support for latest PMC controller

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5fc4118..910d748 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -132,6 +132,7 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
+	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0580},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
@@ -189,6 +190,7 @@ static struct board_type products[] = {
 	{0x21CC103C, "Smart Array", &SA5_access},
 	{0x21CD103C, "Smart Array", &SA5_access},
 	{0x21CE103C, "Smart HBA", &SA5_access},
+	{0x05809005, "SmartHBA-SA", &SA5_access},
 	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
 	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
 	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},

