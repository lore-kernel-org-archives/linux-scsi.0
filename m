From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 6/9] hpsa: mark hpsa_pci_init as __devinit
Date: Thu, 25 Feb 2010 14:03:17 -0600
Message-ID: <20100225200317.7508.24610.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8497 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933551Ab0BYUAJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 15:00:09 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: mark hpsa_pci_init as __devinit

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 3d43bb2..2e1edce 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3174,7 +3174,7 @@ default_int_mode:
 	h->intr[PERF_MODE_INT] = pdev->irq;
 }
 
-static int hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
+static int __devinit hpsa_pci_init(struct ctlr_info *h, struct pci_dev *pdev)
 {
 	ushort subsystem_vendor_id, subsystem_device_id, command;
 	u32 board_id, scratchpad = 0;

