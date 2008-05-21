From: michaelc@cs.wisc.edu
Subject: [PATCH 25/25] scsi: use get_unaligned_* helpers
Date: Wed, 21 May 2008 15:54:20 -0500
Message-ID: <1211403260-5487-26-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-8-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-9-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-10-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-11-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-12-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-13-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-14-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-15-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-16-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-17-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-18-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-19-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-20-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-21-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-22-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-23-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-24-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-25-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936902AbYEUUyk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:40 -0400
In-Reply-To: <1211403260-5487-25-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Harvey Harrison <harvey.harrison@gmail.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 9c267b4..8b4e412 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -591,7 +591,7 @@ invalid_datalen:
 			goto out;
 		}
 
-		senselen = be16_to_cpu(get_unaligned((__be16 *) data));
+		senselen = get_unaligned_be16(data);
 		if (datalen < senselen)
 			goto invalid_datalen;
 
-- 
1.5.4.1

