From: Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v2 1/3] ibmvscsi: make parameters max_id and max_channel read-only
Date: Wed,  4 Nov 2015 11:20:49 +0100
Message-ID: <1446632451-22365-2-git-send-email-lvivier@redhat.com>
References: <1446632451-22365-1-git-send-email-lvivier@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446632451-22365-1-git-send-email-lvivier@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, lvivier@redhat.com
List-Id: linux-scsi@vger.kernel.org

The value of the parameter is never re-read by the driver,
so a new value is ignored. Let know the user he
can't modify it by removing writable attribute.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
---
 drivers/scsi/ibmvscsi/ibmvscsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 6a41c36..3e76490 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -105,9 +105,9 @@ MODULE_AUTHOR("Dave Boutcher");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(IBMVSCSI_VERSION);
 
-module_param_named(max_id, max_id, int, S_IRUGO | S_IWUSR);
+module_param_named(max_id, max_id, int, S_IRUGO);
 MODULE_PARM_DESC(max_id, "Largest ID value for each channel");
-module_param_named(max_channel, max_channel, int, S_IRUGO | S_IWUSR);
+module_param_named(max_channel, max_channel, int, S_IRUGO);
 MODULE_PARM_DESC(max_channel, "Largest channel value");
 module_param_named(init_timeout, init_timeout, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
-- 
2.1.0
