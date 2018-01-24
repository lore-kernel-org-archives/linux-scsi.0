From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv3 1/4] raid_class: Add 'JBOD' RAID level
Date: Wed, 24 Jan 2018 09:07:58 +0100
Message-ID: <20180124080801.82630-2-hare@suse.de>
References: <20180124080801.82630-1-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34789 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932515AbeAXIIF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Jan 2018 03:08:05 -0500
In-Reply-To: <20180124080801.82630-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Not a real RAID level, but some HBAs support JBOD in addition to
the 'classical' RAID levels.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/raid_class.c  | 1 +
 include/linux/raid_class.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 2c146b44d95f..ea88906d2cc5 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -157,6 +157,7 @@ static struct {
 	{ RAID_LEVEL_5, "raid5" },
 	{ RAID_LEVEL_50, "raid50" },
 	{ RAID_LEVEL_6, "raid6" },
+	{ RAID_LEVEL_JBOD, "jbod" },
 };
 
 static const char *raid_level_name(enum raid_level level)
diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
index 31e1ff69efc8..ec8655514283 100644
--- a/include/linux/raid_class.h
+++ b/include/linux/raid_class.h
@@ -38,6 +38,7 @@ enum raid_level {
 	RAID_LEVEL_5,
 	RAID_LEVEL_50,
 	RAID_LEVEL_6,
+	RAID_LEVEL_JBOD,
 };
 
 struct raid_data {
-- 
2.12.3
