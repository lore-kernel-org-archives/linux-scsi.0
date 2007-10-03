From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 06/21] advansys: Remove ASC_SELECT_QUEUE_DEPTHS
Date: Tue,  2 Oct 2007 21:55:27 -0400
Message-ID: <11913765422891-git-send-email-matthew@wil.cx>
References: <11913765421743-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:58769 "EHLO
	mail-07.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821AbXJCBzo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 21:55:44 -0400
In-Reply-To: <11913765421743-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

It was only ever set; never tested, nor cleared.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/scsi/advansys.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 52ea41d..5e6bcf2 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -2230,7 +2230,6 @@ do { \
 
 /* asc_board_t flags */
 #define ASC_IS_WIDE_BOARD       0x04	/* AdvanSys Wide Board */
-#define ASC_SELECT_QUEUE_DEPTHS 0x08
 
 #define ASC_NARROW_BOARD(boardp) (((boardp)->flags & ASC_IS_WIDE_BOARD) == 0)
 #define ASC_WIDE_BOARD(boardp)   ((boardp)->flags & ASC_IS_WIDE_BOARD)
@@ -10135,7 +10134,6 @@ advansys_wide_slave_configure(struct scsi_device *sdev, ADV_DVC_VAR *adv_dvc)
 static int advansys_slave_configure(struct scsi_device *sdev)
 {
 	asc_board_t *boardp = ASC_BOARDP(sdev->host);
-	boardp->flags |= ASC_SELECT_QUEUE_DEPTHS;
 
 	if (ASC_NARROW_BOARD(boardp))
 		advansys_narrow_slave_configure(sdev,
-- 
1.5.3.1

