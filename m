From: Joe Perches <joe@perches.com>
Subject: [PATCH 08/11] drivers/scsi/be2iscsi/be_main.c: Remove unnecessary casts of pci_get_drvdata
Date: Mon, 15 Nov 2010 12:13:59 -0800
Message-ID: <ae40e74f63fb73423dd731aecbe476a08acdb275.1289851770.git.joe@perches.com>
References: <cover.1289851770.git.joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:1337 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933683Ab0KOUOL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Nov 2010 15:14:11 -0500
In-Reply-To: <cover.1289851770.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Kosina <trivial@kernel.org>
Cc: Jayamohan Kallickal <jayamohank@serverengines.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 75a85aa..b00b904 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4103,7 +4103,7 @@ static void beiscsi_remove(struct pci_dev *pcidev)
 	u8 *real_offset = 0;
 	u32 value = 0;
 
-	phba = (struct beiscsi_hba *)pci_get_drvdata(pcidev);
+	phba = pci_get_drvdata(pcidev);
 	if (!phba) {
 		dev_err(&pcidev->dev, "beiscsi_remove called with no phba\n");
 		return;
-- 
1.7.3.1.g432b3.dirty

