From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] cxgbi: typo in MODULE_PARM_DESC
Date: Fri, 8 Jan 2016 14:01:36 +0300
Message-ID: <20160108110136.GG32195@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Karen Xie <kxie@chelsio.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The module_param is "cxgb3i_rx_credit_thres" so the MODULE_PARM_DESC()
should match that.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index 0e2bee9..e22a268 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -57,7 +57,7 @@ MODULE_PARM_DESC(cxgb3i_snd_win, "TCP send window in bytes (default=128KB)");
 
 static int cxgb3i_rx_credit_thres = 10 * 1024;
 module_param(cxgb3i_rx_credit_thres, int, 0644);
-MODULE_PARM_DESC(rx_credit_thres,
+MODULE_PARM_DESC(cxgb3i_rx_credit_thres,
 		 "RX credits return threshold in bytes (default=10KB)");
 
 static unsigned int cxgb3i_max_connect = 8 * 1024;
