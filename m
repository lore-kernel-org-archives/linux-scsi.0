From: Olaf Hering <olh@suse.de>
Subject: [PATCH 32/82] remove linux/version.h from drivers/scsi/amiga7xx.c
Date: Sun, 10 Jul 2005 19:35:40 +0000
Message-ID: <20050710193540.32.LVEivt3124.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261762AbVGJV1u@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/amiga7xx.c |    1 -
1 files changed, 1 deletion(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/amiga7xx.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/amiga7xx.c
+++ linux-2.6.13-rc2-mm1/drivers/scsi/amiga7xx.c
@@ -11,7 +11,6 @@
#include <linux/mm.h>
#include <linux/blkdev.h>
#include <linux/sched.h>
-#include <linux/version.h>
#include <linux/config.h>
#include <linux/zorro.h>
#include <linux/stat.h>
