From: H Hartley Sweeten <hsweeten@visionengravers.com>
Subject: [PATCH] scsi: pcmcia: nsp_cs: remove module init/exit function prototypes
Date: Mon, 15 Apr 2013 09:42:37 -0700
Message-ID: <201304150942.37837.hsweeten@visionengravers.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, JBottomley@parallels.com, yokota@netlab.is.tsukuba.ac.jp, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

This driver now uses the module_pcmcia_driver() macro to supply the
init/exit code. The nsp_cs_{init,exit} prototypes should be removed.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/scsi/pcmcia/nsp_cs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/scsi/pcmcia/nsp_cs.h b/drivers/scsi/pcmcia/nsp_cs.h
index afd64f0..ea5122f 100644
--- a/drivers/scsi/pcmcia/nsp_cs.h
+++ b/drivers/scsi/pcmcia/nsp_cs.h
@@ -326,10 +326,6 @@ static struct Scsi_Host *nsp_detect(struct scsi_host_template *sht);
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
1.8.1.4
