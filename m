From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Subject: [PATCH 1/3] be2iscsi: More time for FW
Date: Wed, 6 Oct 2010 23:45:21 +0530
Message-ID: <20101006181521.GA25755@emulex.com>
Reply-To: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:45179 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759647Ab0JFSQq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2010 14:16:46 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

   This patch provides more time for the FW to respond. This became
necessary in boot situations

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 7c75373..ad24636 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -335,7 +335,7 @@ static int be_mbox_db_ready_wait(struct be_ctrl_info *ctrl)
 		if (ready)
 			break;
 
-		if (cnt > 6000000) {
+		if (cnt > 12000000) {
 			dev_err(&ctrl->pdev->dev, "mbox_db poll timed out\n");
 			return -EBUSY;
 		}
-- 
1.7.1

