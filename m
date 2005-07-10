From: Olaf Hering <olh@suse.de>
Subject: [PATCH 50/82] remove linux/version.h from drivers/scsi/sg.c
Date: Sun, 10 Jul 2005 19:35:58 +0000
Message-ID: <20050710193558.50.eKJcUZ3600.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261206AbVGJTnY@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/sg.c |    4 ----
1 files changed, 4 deletions(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/sg.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/sg.c
+++ linux-2.6.13-rc2-mm1/drivers/scsi/sg.c
@@ -67,10 +67,6 @@ static int sg_proc_init(void);
static void sg_proc_cleanup(void);
#endif

-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif				/* LINUX_VERSION_CODE */
-
#define SG_ALLOW_DIO_DEF 0
#define SG_ALLOW_DIO_CODE /* compile out by commenting this define */
