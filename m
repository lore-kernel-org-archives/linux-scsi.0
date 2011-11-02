From: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH] drivers/scsi/scsi_transport_iscsi.c: Fix documentation os parameter
Date: Wed,  2 Nov 2011 11:17:17 -0200
Message-ID: <1320239837-7138-1-git-send-email-marcos.mage@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53645 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab1KBNUp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Nov 2011 09:20:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michael@cs.wisc.edu
Cc: jbottomley@parallels.com, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, rdunlap@xenotime.net, linux-doc@vger.kernel.org, Marcos Paulo de Souza <marcos.mage@gmail.com>

Fixes documentation of a parameter of iscsi_bsg_host_add function to silence to make htmldocs[

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/scsi/scsi_transport_iscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 1bcd65a..96029e6 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -520,7 +520,7 @@ fail_host_msg:
 /**
  * iscsi_bsg_host_add - Create and add the bsg hooks to receive requests
  * @shost: shost for iscsi_host
- * @cls_host: iscsi_cls_host adding the structures to
+ * @ihost: iscsi_cls_host adding the structures to
  */
 static int
 iscsi_bsg_host_add(struct Scsi_Host *shost, struct iscsi_cls_host *ihost)
-- 
1.7.4.1

