From: "majianpeng" <majianpeng@gmail.com>
Subject: sas_queue_up:remove unused variable
Date: Thu, 3 Nov 2011 13:38:19 +0800
Message-ID: <201111031338165312058@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39601 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab1KCFiN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Nov 2011 01:38:13 -0400
Received: by iage36 with SMTP id e36so942527iag.19
        for <linux-scsi@vger.kernel.org>; Wed, 02 Nov 2011 22:38:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley <JBottomley@Parallels.com>JBottomley <JBottomley@Parallels.com>JBottomley <JBottomley@Parallels.com>JBottomley <JBottomley@Parallels.com>JBottomley <JBot>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

>From 75995bfd9fc4bdbc7830a8bbb15d82ab84cc92c1 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Thu, 3 Nov 2011 11:15:31 +0000
Subject: [PATCH] remove unused variable


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/scsi/libsas/sas_scsi_host.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
index b2c4a77..c13f67d 100644
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -167,7 +167,6 @@ int sas_queue_up(struct sas_task *task)
 	struct sas_ha_struct *sas_ha = task->dev->port->ha;
 	struct scsi_core *core = &sas_ha->core;
 	unsigned long flags;
-	LIST_HEAD(list);
 
 	spin_lock_irqsave(&core->task_queue_lock, flags);
 	if (sas_ha->lldd_queue_size < core->task_queue_size + 1) {
-- 
1.7.3
 				
 				 

--------------
majianpeng
2011-11-03

