From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 2/8] Drivers: scsi: storvsc: Set cmd_per_lun to reflect value supported by the Host
Date: Wed,  9 Jul 2014 23:41:54 -0700
Message-ID: <1404974514-5111-1-git-send-email-kys@microsoft.com>
References: <1404974032-5023-1-git-send-email-kys@microsoft.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1404974032-5023-1-git-send-email-kys@microsoft.com>
Sender: stable-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Set cmd_per_lun to reflect value supported by the Host.
In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8938b13..cebcef7 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1690,7 +1690,7 @@ static struct scsi_host_template scsi_driver = {
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
-	.cmd_per_lun =		1,
+	.cmd_per_lun =		255,
 	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
-- 
1.7.4.1
