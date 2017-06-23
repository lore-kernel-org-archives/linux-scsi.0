From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH] Remove the definition of VLC_SA_RECEIVE_CREDENTIAL
Date: Fri, 23 Jun 2017 10:32:39 -0700
Message-ID: <20170623173239.16901-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:41545 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754860AbdFWRc7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jun 2017 13:32:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

The symbolic name VLC_SA_RECEIVE_CREDENTIAL is not used anywhere
in the kernel. Additionally, since SPC 5 the RECEIVE CREDENTIAL
command is obsolete. The VLC_SA_RECEIVE_CREDENTIAL definition is
misleading since it occurs outside the list of other variable
length CDB service action codes (READ_32, WRITE_32, ...). Hence
remove this definition.

References: commit e9ccc998b70f ("[SCSI] Add missing SPC-4 CDB and MAINTENANCE_[IN,OUT] service action definitions")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 include/scsi/scsi_proto.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index ce78ec8e367d..78215fd6cdfd 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -125,9 +125,6 @@
 #define	SAI_READ_CAPACITY_16  0x10
 #define SAI_GET_LBA_STATUS    0x12
 #define SAI_REPORT_REFERRALS  0x13
-/* values for VARIABLE_LENGTH_CMD service action codes
- * see spc4r17 Section D.3.5, table D.7 and D.8 */
-#define VLC_SA_RECEIVE_CREDENTIAL 0x1800
 /* values for maintenance in */
 #define MI_REPORT_IDENTIFYING_INFORMATION 0x05
 #define MI_REPORT_TARGET_PGS  0x0a
-- 
2.13.1
