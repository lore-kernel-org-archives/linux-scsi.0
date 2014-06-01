From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1] include/scsi/osd_protocol.h: remove unnecessary __constant
Date: Sun,  1 Jun 2014 16:06:53 +0200
Message-ID: <1401631613-25359-1-git-send-email-fabf@skynet.be>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:15800 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751947AbaFAOI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jun 2014 10:08:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@primarydata.com>

__constant_cpu_to_be16 converted to cpu_to_be16

This patch fixes checkpatch warnings:

"WARNING: __constant_cpu_to_be16 should be cpu_to_be16"

Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@primarydata.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 include/scsi/osd_protocol.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/scsi/osd_protocol.h b/include/scsi/osd_protocol.h
index 25ac628..a2594af 100644
--- a/include/scsi/osd_protocol.h
+++ b/include/scsi/osd_protocol.h
@@ -263,16 +263,16 @@ static inline struct osd_cdb_head *osd_cdb_head(struct osd_cdb *ocdb)
  * Ex name = FORMAT_OSD we have OSD_ACT_FORMAT_OSD && OSDv1_ACT_FORMAT_OSD
  */
 #define OSD_ACT___(Name, Num) \
-	OSD_ACT_##Name = __constant_cpu_to_be16(0x8880 + Num), \
-	OSDv1_ACT_##Name = __constant_cpu_to_be16(0x8800 + Num),
+	OSD_ACT_##Name = cpu_to_be16(0x8880 + Num), \
+	OSDv1_ACT_##Name = cpu_to_be16(0x8800 + Num),
 
 /* V2 only actions */
 #define OSD_ACT_V2(Name, Num) \
-	OSD_ACT_##Name = __constant_cpu_to_be16(0x8880 + Num),
+	OSD_ACT_##Name = cpu_to_be16(0x8880 + Num),
 
 #define OSD_ACT_V1_V2(Name, Num1, Num2) \
-	OSD_ACT_##Name = __constant_cpu_to_be16(Num2), \
-	OSDv1_ACT_##Name = __constant_cpu_to_be16(Num1),
+	OSD_ACT_##Name = cpu_to_be16(Num2), \
+	OSDv1_ACT_##Name = cpu_to_be16(Num1),
 
 enum osd_service_actions {
 	OSD_ACT_V2(OBJECT_STRUCTURE_CHECK,	0x00)
-- 
1.8.4.5

