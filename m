From: kbuild test robot <fengguang.wu@intel.com>
Subject: [PATCH scsi] aacraid: aac_src_intr_message() can be static
Date: Fri, 10 Apr 2015 16:53:38 +0800
Message-ID: <20150410085338.GA3332@snb>
References: <201504101622.qu6odppW%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201504101622.qu6odppW%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: kbuild-all@01.org, James Bottomley <JBottomley@Odin.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 src.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c
index 50f181f..79a3ed1 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -46,7 +46,7 @@
 
 static int aac_src_get_sync_status(struct aac_dev *dev);
 
-irqreturn_t aac_src_intr_message(int irq, void *dev_id)
+static irqreturn_t aac_src_intr_message(int irq, void *dev_id)
 {
 	struct aac_msix_ctx *ctx;
 	struct aac_dev *dev;
