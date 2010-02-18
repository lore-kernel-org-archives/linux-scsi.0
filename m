From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] scsi_dh_alua: add netapp to dev list
Date: Thu, 18 Feb 2010 17:32:03 -0600
Message-ID: <1266535923-2728-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab0BRX3x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 18:29:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Newer Netapp target software supports ALUA, so
this patch adds them to the scsi_dev_alua dev list.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 4f0d013..ee372bf 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -717,6 +717,7 @@ static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"IBM", "2145" },
 	{"Pillar", "Axiom" },
 	{"Intel", "Multi-Flex"},
+	{"NETAPP", "LUN"},
 	{NULL, NULL}
 };
 
-- 
1.6.6

