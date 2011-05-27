From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [RESUBMIT PATCH 1/4] bnx2fc: host stats show the link speed
 'unknown' on NIC partitioned interfaces
Date: Fri, 27 May 2011 11:47:25 -0700
Message-ID: <1306522048-23893-2-git-send-email-bprakash@broadcom.com>
References: <1306522048-23893-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3540 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751044Ab1E0Sri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 14:47:38 -0400
In-Reply-To: <1306522048-23893-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

NIC partitioned interfaces reports the speed of 2500 which was not handled by
the driver.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index ab255fb..8f894e4 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -679,6 +679,9 @@ static void bnx2fc_link_speed_update(struct fc_lport *lport)
 		case SPEED_1000:
 			lport->link_speed = FC_PORTSPEED_1GBIT;
 			break;
+		case SPEED_2500:
+			lport->link_speed = FC_PORTSPEED_2GBIT;
+			break;
 		case SPEED_10000:
 			lport->link_speed = FC_PORTSPEED_10GBIT;
 			break;
-- 
1.7.0.6


