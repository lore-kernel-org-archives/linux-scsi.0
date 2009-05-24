From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 01/10 resend] libosd: OSD2r05: Additional command enums
Date: Sun, 24 May 2009 20:00:39 +0300
Message-ID: <1243184439-16881-1-git-send-email-bharrosh@panasas.com>
References: <4A197CB5.60709@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([209.116.51.66]:1853 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753641AbZEXRAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 May 2009 13:00:43 -0400
In-Reply-To: <4A197CB5.60709@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>
Cc: Jeff Garzik <jeff@garzik.org>

Add all constant definitions of new OSD commands added in
revision 4 & 5. Mainly for creating snapshots and clones.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 include/scsi/osd_protocol.h |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index 62b2ab8..2cc8e8b 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -303,7 +303,15 @@ enum osd_service_actions {
 	OSD_ACT_V2(REMOVE_MEMBER_OBJECTS,	0x21)
 	OSD_ACT_V2(GET_MEMBER_ATTRIBUTES,	0x22)
 	OSD_ACT_V2(SET_MEMBER_ATTRIBUTES,	0x23)
+
+	OSD_ACT_V2(CREATE_CLONE,		0x28)
+	OSD_ACT_V2(CREATE_SNAPSHOT,		0x29)
+	OSD_ACT_V2(DETACH_CLONE,		0x2A)
+	OSD_ACT_V2(REFRESH_SNAPSHOT_CLONE,	0x2B)
+	OSD_ACT_V2(RESTORE_PARTITION_FROM_SNAPSHOT, 0x2C)
+
 	OSD_ACT_V2(READ_MAP,			0x31)
+	OSD_ACT_V2(READ_MAPS_COMPARE,		0x32)
 
 	OSD_ACT_V1_V2(PERFORM_SCSI_COMMAND,	0x8F7E, 0x8F7C)
 	OSD_ACT_V1_V2(SCSI_TASK_MANAGEMENT,	0x8F7F, 0x8F7D)
-- 
1.6.2.1

