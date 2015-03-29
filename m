From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 60/86] scsi/arcmsr: use uapi/linux/pci_ids.h directly
Date: Sun, 29 Mar 2015 15:41:58 +0200
Message-ID: <1427635734-24786-61-git-send-email-mst@redhat.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1427635734-24786-1-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, Ching Huang <ching2048@areca.com.tw>, Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Header moved from linux/pci_ids.h to uapi/linux/pci_ids.h,
use the new header directly so we can drop
the wrapper in include/linux/pci_ids.h.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 914c39f..ead6f31 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -47,7 +47,7 @@
 #include <linux/module.h>
 #include <linux/reboot.h>
 #include <linux/spinlock.h>
-#include <linux/pci_ids.h>
+#include <uapi/linux/pci_ids.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/errno.h>
-- 
MST
