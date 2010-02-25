From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 2/9] hpsa: fix firmwart typo
Date: Thu, 25 Feb 2010 14:02:56 -0600
Message-ID: <20100225200256.7508.87846.stgit@beardog.cce.hp.com>
References: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20920 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933430Ab0BYT7r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:59:47 -0500
In-Reply-To: <20100225200125.7508.11486.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: james.bottomley@suse.de, mikem@beardog.cce.hp.com

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: fix firmwart typo

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 745c624..3734f31 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2982,7 +2982,7 @@ static irqreturn_t do_hpsa_intr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-/* Send a message CDB to the firmwart. */
+/* Send a message CDB to the firmware. */
 static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 						unsigned char type)
 {

