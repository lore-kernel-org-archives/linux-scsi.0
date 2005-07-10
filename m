From: Olaf Hering <olh@suse.de>
Subject: [PATCH 49/82] remove linux/version.h from drivers/scsi/scsi_debug.c
Date: Sun, 10 Jul 2005 19:35:57 +0000
Message-ID: <20050710193557.49.eHfyeO3572.2247.olh@nectarine.suse.de>
References: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.suse.de ([195.135.220.2]:10387 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S261849AbVGJTf5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Jul 2005 15:35:57 -0400
Content-Disposition: inline
In-Reply-To: <20050710193508.0.PmFpst2252.2247.olh@nectarine.suse.de>  
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


changing CONFIG_LOCALVERSION rebuilds too much, for no appearent reason.

Signed-off-by: Olaf Hering <olh@suse.de>

drivers/scsi/scsi_debug.c |    4 ----
1 files changed, 4 deletions(-)

Index: linux-2.6.13-rc2-mm1/drivers/scsi/scsi_debug.c
===================================================================
--- linux-2.6.13-rc2-mm1.orig/drivers/scsi/scsi_debug.c
+++ linux-2.6.13-rc2-mm1/drivers/scsi/scsi_debug.c
@@ -48,10 +48,6 @@

#include <linux/stat.h>

-#ifndef LINUX_VERSION_CODE
-#include <linux/version.h>
-#endif
-
#include "scsi_logging.h"
#include "scsi_debug.h"

