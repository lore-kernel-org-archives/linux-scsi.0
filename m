From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] scsi dh alua: add intel Multi-Flex device
Date: Fri, 30 Jan 2009 17:00:10 -0600
Message-ID: <12333564124151-git-send-email-michaelc@cs.wisc.edu>
References: <12333564114078-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53958 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZA3XAQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jan 2009 18:00:16 -0500
In-Reply-To: <12333564114078-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ilgu Hong <ilgu.hong@promise.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Ilgu Hong <ilgu.hong@promise.com>

This adds the Intel Multi-Flex device to scsi_dh_alua's
scsi_dh_devlist, so the module attaches to these devs.

Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 5096b0b..31e1df5 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -691,6 +691,7 @@ static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"IBM", "2107900" },
 	{"IBM", "2145" },
 	{"Pillar", "Axiom" },
+	{"Intel", "Multi-Flex"},
 	{NULL, NULL}
 };
 
-- 
1.6.0.6

