From: Mike Miller <mike.miller@hp.com>
Subject: [PATCH 5/4] hpsa: remove unused Smart Array ID
Date: Tue, 10 Sep 2013 13:18:23 -0500
Message-ID: <20130910181823.GA12247@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, thenzl@redhat.com, jshortt@redhat.com
List-Id: linux-scsi@vger.kernel.org

Patch 5 of 4

From: Mike Miller <mike.miller@hp.com>

This patch removes the PCI ID of a cancelled Smart Array. I missed that in my
previous submissions. If preferred I can redo the entire patchset I submitted
last week. Please advise.
---
 drivers/scsi/hpsa.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9bf6304..479a387 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -100,7 +100,6 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
-	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
 	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
