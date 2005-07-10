From: Olaf Hering <olh@suse.de>
Subject: [PATCH 33/82] remove linux/version.h from drivers/scsi/arcmsr
Date: Sun, 10 Jul 2005 19:35:41 +0000
Message-ID: <20050710193541.33.RXSOKn3150.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261784AbVGJV1u@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/arcmsr/arcmsr.c |    1 -
drivers/scsi/arcmsr/arcmsr.h |    1 -
2 files changed, 2 deletions(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/arcmsr/arcmsr.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/arcmsr/arcmsr.c
+++ linux-2.6.13-rc2-mm1/drivers/scsi/arcmsr/arcmsr.c
@@ -81,7 +81,6 @@
#include <config/modversions.h>
#endif
#include <linux/module.h>
-#include <linux/version.h>
/* Now your module include files & source code follows */
#include <asm/dma.h>
#include <asm/io.h>
Index: linux-2.6.13-rc2-mm1/drivers/scsi/arcmsr/arcmsr.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/arcmsr/arcmsr.h
+++ linux-2.6.13-rc2-mm1/drivers/scsi/arcmsr/arcmsr.h
@@ -43,7 +43,6 @@
**************************************************************************
*/
#include <linux/config.h>
-#include <linux/version.h>

#if defined(__SMP__) && !defined(CONFIG_SMP)
# define CONFIG_SMP
