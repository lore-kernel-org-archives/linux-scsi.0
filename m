From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] scsi: Add VENDOR_SPECIFIC sense code definitions
Date: Fri, 19 Jan 2018 16:11:10 +0100
Message-ID: <20180119151113.80768-3-hare@suse.de>
References: <20180119151113.80768-1-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44188 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755524AbeASPLS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 10:11:18 -0500
In-Reply-To: <20180119151113.80768-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Some older devices will return vendor specific sense codes, so
we should be adding a definition for it.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 include/scsi/scsi_proto.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
index 1df8efb0ee01..c36860111932 100644
--- a/include/scsi/scsi_proto.h
+++ b/include/scsi/scsi_proto.h
@@ -236,6 +236,7 @@ struct scsi_varlen_cdb_hdr {
 #define UNIT_ATTENTION      0x06
 #define DATA_PROTECT        0x07
 #define BLANK_CHECK         0x08
+#define VENDOR_SPECIFIC     0x09
 #define COPY_ABORTED        0x0a
 #define ABORTED_COMMAND     0x0b
 #define VOLUME_OVERFLOW     0x0d
-- 
2.12.3
