From: Olaf Hering <olh@suse.de>
Subject: [PATCH 38/82] remove linux/version.h from drivers/scsi/gvp11.c
Date: Sun, 10 Jul 2005 19:35:46 +0000
Message-ID: <20050710193546.38.roMdrq3282.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261801AbVGJVgk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/gvp11.c |    1 -
1 files changed, 1 deletion(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/gvp11.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/gvp11.c
+++ linux-2.6.13-rc2-mm1/drivers/scsi/gvp11.c
@@ -2,7 +2,6 @@
#include <linux/mm.h>
#include <linux/blkdev.h>
#include <linux/sched.h>
-#include <linux/version.h>
#include <linux/init.h>
#include <linux/interrupt.h>
