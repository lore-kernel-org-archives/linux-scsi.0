From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/4] raid_class: Add 'JBOD' RAID level
Date: Wed,  2 Aug 2017 16:13:25 +0200
Message-ID: <1501683208-5240-2-git-send-email-hare@suse.de>
References: <1501683208-5240-1-git-send-email-hare@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1501683208-5240-1-git-send-email-hare@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Not a real RAID level, but some HBAs support JBOD in addition to
the 'classical' RAID levels.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/raid_class.c  | 1 +
 include/linux/raid_class.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/scsi/raid_class.c b/drivers/scsi/raid_class.c
index 2c146b4..ea88906 100644
--- a/drivers/scsi/raid_class.c
+++ b/drivers/scsi/raid_class.c
@@ -157,6 +157,7 @@ static const char *raid_state_name(enum raid_state state)
 	{ RAID_LEVEL_5, "raid5" },
 	{ RAID_LEVEL_50, "raid50" },
 	{ RAID_LEVEL_6, "raid6" },
+	{ RAID_LEVEL_JBOD, "jbod" },
 };
 
 static const char *raid_level_name(enum raid_level level)
diff --git a/include/linux/raid_class.h b/include/linux/raid_class.h
index 31e1ff6..ec86555 100644
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
1.8.5.6
