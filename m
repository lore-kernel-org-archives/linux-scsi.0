From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi: add scsi target reset support to scsi ioctl
Date: Thu,  5 Nov 2009 11:37:28 -0600
Message-ID: <1257442648-7215-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970AbZKERh0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Nov 2009 12:37:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The scsi ioctl code path was missing scsi target reset
support. This patch just adds it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_ioctl.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index b98f763..d9564fb 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -308,6 +308,9 @@ int scsi_nonblockable_ioctl(struct scsi_device *sdev, int cmd,
 		case SG_SCSI_RESET_DEVICE:
 			val = SCSI_TRY_RESET_DEVICE;
 			break;
+		case SG_SCSI_RESET_TARGET:
+			val = SCSI_TRY_RESET_TARGET;
+			break;
 		case SG_SCSI_RESET_BUS:
 			val = SCSI_TRY_RESET_BUS;
 			break;
-- 
1.6.0.6

