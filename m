From: Olaf Hering <olh@suse.de>
Subject: [PATCH 42/82] remove linux/version.h from drivers/scsi/megaraid
Date: Sun, 10 Jul 2005 19:35:50 +0000
Message-ID: <20050710193550.42.tKRWic3388.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262077AbVGJVgm@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/megaraid/mega_common.h |    1 -
drivers/scsi/megaraid/megaraid_mm.h |    1 -
2 files changed, 2 deletions(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/megaraid/mega_common.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/megaraid/mega_common.h
+++ linux-2.6.13-rc2-mm1/drivers/scsi/megaraid/mega_common.h
@@ -25,7 +25,6 @@
#include <linux/delay.h>
#include <linux/blkdev.h>
#include <linux/list.h>
-#include <linux/version.h>
#include <linux/moduleparam.h>
#include <linux/dma-mapping.h>
#include <asm/semaphore.h>
Index: linux-2.6.13-rc2-mm1/drivers/scsi/megaraid/megaraid_mm.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/megaraid/megaraid_mm.h
+++ linux-2.6.13-rc2-mm1/drivers/scsi/megaraid/megaraid_mm.h
@@ -18,7 +18,6 @@
#include <linux/spinlock.h>
#include <linux/fs.h>
#include <asm/uaccess.h>
-#include <linux/version.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/pci.h>
