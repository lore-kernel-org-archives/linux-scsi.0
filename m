From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] nvme: mark nvme_max_retries static
Date: Wed,  5 Apr 2017 19:18:10 +0200
Message-ID: <20170405171812.19911-4-hch@lst.de>
References: <20170405171812.19911-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405171812.19911-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/nvme/host/core.c | 3 +--
 drivers/nvme/host/nvme.h | 2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index b225aacf4b89..933e67c60e33 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -49,10 +49,9 @@ unsigned char shutdown_timeout = 5;
 module_param(shutdown_timeout, byte, 0644);
 MODULE_PARM_DESC(shutdown_timeout, "timeout in seconds for controller shutdown");
 
-unsigned int nvme_max_retries = 5;
+static unsigned int nvme_max_retries = 5;
 module_param_named(max_retries, nvme_max_retries, uint, 0644);
 MODULE_PARM_DESC(max_retries, "max number of retries a command may have");
-EXPORT_SYMBOL_GPL(nvme_max_retries);
 
 static int nvme_char_major;
 module_param(nvme_char_major, int, 0);
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 227f281482db..82ba9a305301 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -43,8 +43,6 @@ extern unsigned char shutdown_timeout;
 #define NVME_DEFAULT_KATO	5
 #define NVME_KATO_GRACE		10
 
-extern unsigned int nvme_max_retries;
-
 enum {
 	NVME_NS_LBA		= 0,
 	NVME_NS_LIGHTNVM	= 1,
-- 
2.11.0
