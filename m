From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4/5] [SCSI] scsi_dh_alua: Add Promise VTrak to dev list
Date: Wed,  5 Jan 2011 16:00:23 -0500
Message-ID: <1294261224-12599-5-git-send-email-snitzer@redhat.com>
References: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab1AEVBl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 16:01:41 -0500
In-Reply-To: <1294261224-12599-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Ilgu Hong <ilgu.hong@promise.com>, Joseph Gruher <joseph.r.gruher@intel.com>, Mike Snitzer <snitzer@redhat.com>

From: Ilgu Hong <ilgu.hong@promise.com>

Adds Promise VTrak devices to the ALUA device handler.

Signed-off-by: Ilgu Hong <ilgu.hong@promise.com>
Signed-off-by: Joseph Gruher <joseph.r.gruher@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 9bd2c8a..c1fd09d 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -733,6 +733,7 @@ static const struct scsi_dh_devlist alua_dev_list[] = {
 	{"Intel", "Multi-Flex"},
 	{"NETAPP", "LUN"},
 	{"AIX", "NVDISK"},
+	{"Promise", "VTrak"},
 	{NULL, NULL}
 };
 
-- 
1.7.3.4

