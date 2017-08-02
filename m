From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] scsi: Add VENDOR_SPECIFIC sense code definitions
Date: Wed,  2 Aug 2017 16:13:26 +0200
Message-ID: <1501683208-5240-3-git-send-email-hare@suse.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36458 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752241AbdHBOOS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Aug 2017 10:14:18 -0400
In-Reply-To: <1501683208-5240-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some older devices will return vendor specific sense codes, so
we should be adding a definition for it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/scsi/scsi_proto.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 78215fd..06751a9 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -233,6 +233,7 @@ struct scsi_varlen_cdb_hdr {
 #define UNIT_ATTENTION      0x06
 #define DATA_PROTECT        0x07
 #define BLANK_CHECK         0x08
+#define VENDOR_SPECIFIC     0x09
 #define COPY_ABORTED        0x0a
 #define ABORTED_COMMAND     0x0b
 #define VOLUME_OVERFLOW     0x0d
-- 
1.8.5.6
