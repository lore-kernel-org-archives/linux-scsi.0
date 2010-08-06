From: Dan Carpenter <error27@gmail.com>
Subject: [PATCH] scsi: mpt2sas: Add space in printk
Date: Fri, 6 Aug 2010 09:59:14 +0200
Message-ID: <20100806075914.GS9031@bicker>
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, eric.moore@lsi.com, kashyap.desai@lsi.com
List-Id: linux-scsi@vger.kernel.org

Add a space in the output:
old:  Discovery: (stop)discovery_status(0x%08x)
new:  Discovery: (stop) discovery_status(0x%08x)

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This goes on top of Julia's [PATCH 9/42] drivers/scsi: Adjust
confusing if indentation 

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 12faf64..562b909 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -532,7 +532,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 		if (event_data->DiscoveryStatus)
-			printk("discovery_status(0x%08x)",
+			printk(" discovery_status(0x%08x)",
 			    le32_to_cpu(event_data->DiscoveryStatus));
 		printk("\n");
 		return;
