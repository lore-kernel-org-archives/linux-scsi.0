From: Rob Evers <revers@redhat.com>
Subject: [PATCH 2/2] scsi_io_completion: remove confusing unhandled messages
Date: Fri, 12 Aug 2011 17:01:17 -0400
Message-ID: <1313182877-31377-2-git-send-email-revers@redhat.com>
References: <1313182877-31377-1-git-send-email-revers@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1HLVBS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 17:01:18 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p7CL1IJ2032138
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 17:01:18 -0400
Received: from localhost (dhcp-100-19-182.bos.redhat.com [10.16.19.182])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id p7CL1HQ9014365
	for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2011 17:01:18 -0400
In-Reply-To: <1313182877-31377-1-git-send-email-revers@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

remove message when host_byte case is not specifically handled.
remove message when sense_key case is not specifically handled.

Signed-off-by: Rob Evers <revers@redhat.com>
---
 drivers/scsi/scsi_lib.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index fc3f168..e6a359c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -920,12 +920,10 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 			action = ACTION_FAIL;
 			break;
 		default:
-			description = "Unhandled sense code";
 			action = ACTION_FAIL;
 			break;
 		}
 	} else {
-		description = "Unhandled error code";
 		action = ACTION_FAIL;
 	}
 
-- 
1.7.1

