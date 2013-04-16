From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/02] scsi: pcmcia: nsp_cs: remove module init/exit function
 prototypes
Date: Tue, 16 Apr 2013 10:00:44 -0700
Message-ID: <20130416170044.GB3950@kroah.com>
References: <20130416165143.GA3950@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:41941 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935825Ab3DPRAw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 13:00:52 -0400
Received: by mail-pa0-f53.google.com with SMTP id bh4so442675pad.40
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 10:00:52 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20130416165143.GA3950@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Juergen E. Fischer" <fischer@norbit.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hsweeten@visionengravers.com>

This driver now uses the module_pcmcia_driver() macro to supply the
init/exit code. The nsp_cs_{init,exit} prototypes should be removed.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/pcmcia/nsp_cs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index 7fc9a9d..4d4b4f5 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -331,10 +331,6 @@ static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
 /* Interrupt handler */
 //static irqreturn_t nspintr(int irq, void *dev_id);
 
-/* Module entry point*/
-static int  __init nsp_cs_init(void);
-static void __exit nsp_cs_exit(void);
-
 /* Debug */
 #ifdef NSP_DEBUG
 static void show_command (struct scsi_cmnd *SCpnt);
-- 
1.8.2.1.368.g99c2266

