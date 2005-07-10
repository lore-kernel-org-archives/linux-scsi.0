From: Olaf Hering <olh@suse.de>
Subject: [PATCH 29/82] remove linux/version.h from drivers/scsi/3w-xxxx.h
Date: Sun, 10 Jul 2005 19:35:37 +0000
Message-ID: <20050710193537.29.YyPlzr3046.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261708AbVGJVSZ@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/3w-xxxx.h |    1 -
1 files changed, 1 deletion(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/3w-xxxx.h
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/3w-xxxx.h
+++ linux-2.6.13-rc2-mm1/drivers/scsi/3w-xxxx.h
@@ -54,7 +54,6 @@
#ifndef _3W_XXXX_H
#define _3W_XXXX_H

-#include <linux/version.h>
#include <linux/types.h>

/* AEN strings */
