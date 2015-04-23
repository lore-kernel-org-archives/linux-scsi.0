From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 41/42] hpsa: add in new controller id
Date: Thu, 23 Apr 2015 09:35:27 -0500
Message-ID: <20150423143527.18832.46693.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5009.houston.hp.com ([15.240.92.67]:46531 "EHLO
	g9t5009.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966036AbbDWOge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:36:34 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

add in support for latest PMC controller

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9de7173..1aebcfe 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -131,6 +131,7 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CD},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CE},
+	{PCI_VENDOR_ID_ADAPTEC2, 0x0290, 0x9005, 0x0580},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0076},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x0087},
 	{PCI_VENDOR_ID_HP_3PAR, 0x0075, 0x1590, 0x007D},
@@ -188,6 +189,7 @@ static struct board_type products[] = {
 	{0x21CC103C, "Smart Array", &SA5_access},
 	{0x21CD103C, "Smart Array", &SA5_access},
 	{0x21CE103C, "Smart HBA", &SA5_access},
+	{0x05809005, "SmartHBA-SA", &SA5_access},
 	{0x00761590, "HP Storage P1224 Array Controller", &SA5_access},
 	{0x00871590, "HP Storage P1224e Array Controller", &SA5_access},
 	{0x007D1590, "HP Storage P1228 Array Controller", &SA5_access},

