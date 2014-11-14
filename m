From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 03/13] hpsa: fix a couple pci id table mistakes
Date: Fri, 14 Nov 2014 17:26:38 -0600
Message-ID: <20141114232638.20808.11446.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t2354.austin.hp.com ([15.217.128.53]:37081 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422756AbaKNXZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:03 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Fix a couple of pci id table mistakes:
Subdevice ID 0x3323 missing from product[] table
	(another name for HP Smart Storage 1210m)
Bogus 0x1925 subdevice id removed from hpsa_pci_device_id[] (no such thing.)

Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Webb Scales <webbnh@hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e24b304..ed92e9e 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -104,7 +104,6 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1925},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
@@ -150,6 +149,7 @@ static struct board_type products[] = {
 	{0x3249103C, "Smart Array P812", &SA5_access},
 	{0x324A103C, "Smart Array P712m", &SA5_access},
 	{0x324B103C, "Smart Array P711m", &SA5_access},
+	{0x3233103C, "HP StorageWorks 1210m", &SA5_access}, /* alias of 333f */
 	{0x3350103C, "Smart Array P222", &SA5_access},
 	{0x3351103C, "Smart Array P420", &SA5_access},
 	{0x3352103C, "Smart Array P421", &SA5_access},

