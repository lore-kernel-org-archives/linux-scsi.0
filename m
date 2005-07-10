From: Olaf Hering <olh@suse.de>
Subject: [PATCH 39/82] remove linux/version.h from drivers/scsi/ibmmca.c
Date: Sun, 10 Jul 2005 19:35:47 +0000
Message-ID: <20050710193547.39.URTrWX3308.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261807AbVGJVgl@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/ibmmca.c |    6 ------
1 files changed, 6 deletions(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/ibmmca.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/ibmmca.c
+++ linux-2.6.13-rc2-mm1/drivers/scsi/ibmmca.c
@@ -18,12 +18,6 @@
*/

#include <linux/config.h>
-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,45)
-#error "This driver works only with kernel 2.5.45 or higher!"
-#endif
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/types.h>
