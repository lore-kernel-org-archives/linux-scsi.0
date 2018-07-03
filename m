From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [RFC] scsi: switch to scsi-mq by default
Date: Tue,  3 Jul 2018 08:54:13 +0200
Message-ID: <20180703065413.6098-1-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Ming Lei <tom.leiming@gmail.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

It has been more than one year since we tried to change the default
from legacy to multi queue in SCSI. Back then we had to retract the
change because of performance issues with rotating disks.

In the meantime there have been a substantial amount of performance
improvements, thus we can re-enable scsi-mq without a significant
performance penalty.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 35c909bbf8ba..bd115bab162e 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -49,6 +49,7 @@ config SCSI_NETLINK
 
 config SCSI_MQ_DEFAULT
 	bool "SCSI: use blk-mq I/O path by default"
+	default y
 	depends on SCSI
 	---help---
 	  This option enables the new blk-mq based I/O path for SCSI
-- 
2.16.4
