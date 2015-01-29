From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH 3/4] File header and user visible string changes
Date: Thu, 29 Jan 2015 03:55:56 -0500
Message-ID: <1422521757-18724-4-git-send-email-anil.gurumurthy@qlogic.com>
References: <1422521757-18724-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32926 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932705AbbA2Jfc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2015 04:35:32 -0500
In-Reply-To: <1422521757-18724-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfa.h           |    2 +-
 drivers/scsi/bfa/bfa_core.c      |    2 +-
 drivers/scsi/bfa/bfa_cs.h        |    2 +-
 drivers/scsi/bfa/bfa_defs.h      |    2 +-
 drivers/scsi/bfa/bfa_defs_fcs.h  |    2 +-
 drivers/scsi/bfa/bfa_defs_svc.h  |    2 +-
 drivers/scsi/bfa/bfa_fc.h        |    2 +-
 drivers/scsi/bfa/bfa_fcbuild.c   |    2 +-
 drivers/scsi/bfa/bfa_fcbuild.h   |    2 +-
 drivers/scsi/bfa/bfa_fcpim.c     |    2 +-
 drivers/scsi/bfa/bfa_fcpim.h     |    2 +-
 drivers/scsi/bfa/bfa_fcs.c       |    2 +-
 drivers/scsi/bfa/bfa_fcs.h       |    4 +-
 drivers/scsi/bfa/bfa_fcs_fcpim.c |    2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c |    2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c |    2 +-
 drivers/scsi/bfa/bfa_hw_cb.c     |    2 +-
 drivers/scsi/bfa/bfa_hw_ct.c     |    2 +-
 drivers/scsi/bfa/bfa_ioc.c       |    4 +-
 drivers/scsi/bfa/bfa_ioc.h       |    2 +-
 drivers/scsi/bfa/bfa_ioc_cb.c    |    2 +-
 drivers/scsi/bfa/bfa_ioc_ct.c    |    2 +-
 drivers/scsi/bfa/bfa_modules.h   |    2 +-
 drivers/scsi/bfa/bfa_plog.h      |    2 +-
 drivers/scsi/bfa/bfa_port.c      |    2 +-
 drivers/scsi/bfa/bfa_port.h      |    2 +-
 drivers/scsi/bfa/bfa_svc.c       |    2 +-
 drivers/scsi/bfa/bfa_svc.h       |    2 +-
 drivers/scsi/bfa/bfad.c          |   19 ++++------
 drivers/scsi/bfa/bfad_attr.c     |   70 +++++++++++++++++++-------------------
 drivers/scsi/bfa/bfad_bsg.c      |    2 +-
 drivers/scsi/bfa/bfad_bsg.h      |    2 +-
 drivers/scsi/bfa/bfad_debugfs.c  |    2 +-
 drivers/scsi/bfa/bfad_drv.h      |    2 +-
 drivers/scsi/bfa/bfad_im.c       |    4 +-
 drivers/scsi/bfa/bfad_im.h       |    2 +-
 drivers/scsi/bfa/bfi.h           |    2 +-
 drivers/scsi/bfa/bfi_ms.h        |    2 +-
 drivers/scsi/bfa/bfi_reg.h       |    4 +-
 39 files changed, 83 insertions(+), 88 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 7d0337b..0e119d8 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index f157a37..2ea0db4 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index c8bb20a..da9cf65 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index da4f705..5dc3782 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h b/drivers/scsi/bfa/bfa_defs_fcs.h
index 5185ae3..5815a90 100644
--- a/drivers/scsi/bfa/bfa_defs_fcs.h
+++ b/drivers/scsi/bfa/bfa_defs_fcs.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index fd2fa24..e81707f 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 7142309..18b7304 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index 6f670d3..b8dadc9 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 85e3c58..b109a88 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index 3881a72..20982e7 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index 0c37062..e93921d 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 043d3c0..1e7e139 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 30b4555..06dc215 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
@@ -634,7 +634,7 @@ void bfa_fcs_fcpim_uf_recv(struct bfa_fcs_itnim_s *itnim,
 
 /*
  * HBA Attribute Block : BFA internal representation. Note : Some variable
- * sizes have been trimmed to suit BFA For Ex : Model will be "Brocade". Based
+ * sizes have been trimmed to suit BFA For Ex : Model will be "QLogic ". Based
  * on this the size has been reduced to 16 bytes from the standard's 64 bytes.
  */
 struct bfa_fcs_fdmi_hba_attr_s {
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 4fd20d9..4f089d7 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 4631630..7733ad5 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 5559faa..de50349 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index e3648d9..c4a0c0e 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index f19bc44..b0ff378 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index f9856b1..2dc979d 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
@@ -2698,7 +2698,7 @@ bfa_ioc_reset_fwstate(struct bfa_ioc_s *ioc)
 	bfa_ioc_set_alt_ioc_fwstate(ioc, BFI_IOC_UNINIT);
 }
 
-#define BFA_MFG_NAME "Brocade"
+#define BFA_MFG_NAME "QLogic"
 void
 bfa_ioc_get_adapter_attr(struct bfa_ioc_s *ioc,
 			 struct bfa_adapter_attr_s *ad_attr)
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index 0d6e165..713745d 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 10a0042..f1b80da 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 1e5fa61..651a8fb 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 5b02415..53135f2 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.h
index 4fdba6f..da570c0 100644
--- a/drivers/scsi/bfa/bfa_plog.h
+++ b/drivers/scsi/bfa/bfa_plog.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 314548a..da1721e 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_port.h b/drivers/scsi/bfa/bfa_port.h
index ba715ce..26dc1bf 100644
--- a/drivers/scsi/bfa/bfa_port.h
+++ b/drivers/scsi/bfa/bfa_port.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 93e588f..12de292 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index efb0497..ea2278b 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 81d8ff6..122e21b 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
@@ -131,13 +131,9 @@ MODULE_PARM_DESC(bfa_linkup_delay, "Link up delay, default=30 secs for "
 			"boot port. Otherwise 10 secs in RHEL4 & 0 for "
 			"[RHEL5, SLES10, ESX40] Range[>0]");
 module_param(msix_disable_cb, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(msix_disable_cb, "Disable Message Signaled Interrupts "
-			"for Brocade-415/425/815/825 cards, default=0, "
-			" Range[false:0|true:1]");
+MODULE_PARM_DESC(msix_disable_cb, "Disable Message Signaled Interrupts for QLogic-415/425/815/825 cards, default=0 Range[false:0|true:1]");
 module_param(msix_disable_ct, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(msix_disable_ct, "Disable Message Signaled Interrupts "
-			"if possible for Brocade-1010/1020/804/1007/902/1741 "
-			"cards, default=0, Range[false:0|true:1]");
+MODULE_PARM_DESC(msix_disable_ct, "Disable Message Signaled Interrupts if possible for QLogic-1010/1020/804/1007/902/1741 cards, default=0, Range[false:0|true:1]");
 module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(fdmi_enable, "Enables fdmi registration, default=1, "
 				"Range[false:0|true:1]");
@@ -839,8 +835,7 @@ bfad_drv_init(struct bfad_s *bfad)
 		printk(KERN_WARNING "bfad%d bfad_hal_mem_alloc failure\n",
 		       bfad->inst_no);
 		printk(KERN_WARNING
-			"Not enough memory to attach all Brocade HBA ports, %s",
-			"System may need more memory.\n");
+			"Not enough memory to attach all QLogic BR-series HBA ports, %s. System may need more memory.\n");
 		return BFA_STATUS_FAILED;
 	}
 
@@ -1715,7 +1710,7 @@ bfad_init(void)
 {
 	int		error = 0;
 
-	printk(KERN_INFO "Brocade BFA FC/FCOE SCSI driver - version: %s\n",
+	pr_info("QLogic BR-series BFA FC/FCOE SCSI driver - version: %s\n",
 			BFAD_DRIVER_VERSION);
 
 	if (num_sgpgs > 0)
@@ -1822,6 +1817,6 @@ bfad_free_fwimg(void)
 module_init(bfad_init);
 module_exit(bfad_exit);
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Brocade Fibre Channel HBA Driver" BFAD_PROTO_NAME);
-MODULE_AUTHOR("Brocade Communications Systems, Inc.");
+MODULE_DESCRIPTION("QLogic BR-series Fibre Channel HBA Driver" BFAD_PROTO_NAME);
+MODULE_AUTHOR("QLogic Corporation");
 MODULE_VERSION(BFAD_DRIVER_VERSION);
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 66cca48..13db3b7 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
@@ -751,65 +751,65 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 
 	bfa_get_adapter_model(&bfad->bfa, model);
 	nports = bfa_get_nports(&bfad->bfa);
-	if (!strcmp(model, "Brocade-425"))
+	if (!strcmp(model, "QLogic-425"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe dual port FC HBA");
-	else if (!strcmp(model, "Brocade-825"))
+			"QLogic BR-series 4Gbps PCIe dual port FC HBA");
+	else if (!strcmp(model, "QLogic-825"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe dual port FC HBA");
-	else if (!strcmp(model, "Brocade-42B"))
+			"QLogic BR-series 8Gbps PCIe dual port FC HBA");
+	else if (!strcmp(model, "QLogic-42B"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe dual port FC HBA for HP");
-	else if (!strcmp(model, "Brocade-82B"))
+			"QLogic BR-series 4Gbps PCIe dual port FC HBA for HP");
+	else if (!strcmp(model, "QLogic-82B"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe dual port FC HBA for HP");
-	else if (!strcmp(model, "Brocade-1010"))
+			"QLogic BR-series 8Gbps PCIe dual port FC HBA for HP");
+	else if (!strcmp(model, "QLogic-1010"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps single port CNA");
-	else if (!strcmp(model, "Brocade-1020"))
+			"QLogic BR-series 10Gbps single port CNA");
+	else if (!strcmp(model, "QLogic-1020"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps dual port CNA");
-	else if (!strcmp(model, "Brocade-1007"))
+			"QLogic BR-series 10Gbps dual port CNA");
+	else if (!strcmp(model, "QLogic-1007"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps CNA for IBM Blade Center");
-	else if (!strcmp(model, "Brocade-415"))
+			"QLogic BR-series 10Gbps CNA for IBM Blade Center");
+	else if (!strcmp(model, "QLogic-415"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe single port FC HBA");
-	else if (!strcmp(model, "Brocade-815"))
+			"QLogic BR-series 4Gbps PCIe single port FC HBA");
+	else if (!strcmp(model, "QLogic-815"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe single port FC HBA");
-	else if (!strcmp(model, "Brocade-41B"))
+			"QLogic BR-series 8Gbps PCIe single port FC HBA");
+	else if (!strcmp(model, "QLogic-41B"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 4Gbps PCIe single port FC HBA for HP");
-	else if (!strcmp(model, "Brocade-81B"))
+			"QLogic BR-series 4Gbps PCIe single port FC HBA for HP");
+	else if (!strcmp(model, "QLogic-81B"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps PCIe single port FC HBA for HP");
-	else if (!strcmp(model, "Brocade-804"))
+			"QLogic BR-series 8Gbps PCIe single port FC HBA for HP");
+	else if (!strcmp(model, "QLogic-804"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 8Gbps FC HBA for HP Bladesystem C-class");
-	else if (!strcmp(model, "Brocade-1741"))
+			"QLogic BR-series 8Gbps FC HBA for HP Bladesystem C-class");
+	else if (!strcmp(model, "QLogic-1741"))
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-			"Brocade 10Gbps CNA for Dell M-Series Blade Servers");
-	else if (strstr(model, "Brocade-1860")) {
+			"QLogic BR-series 10Gbps CNA for Dell M-Series Blade Servers");
+	else if (strstr(model, "QLogic-1860")) {
 		if (nports == 1 && bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 10Gbps single port CNA");
+				"QLogic BR-series 10Gbps single port CNA");
 		else if (nports == 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe single port FC HBA");
+				"QLogic BR-series 16Gbps PCIe single port FC HBA");
 		else if (nports == 2 && bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 10Gbps dual port CNA");
+				"QLogic BR-series 10Gbps dual port CNA");
 		else if (nports == 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe dual port FC HBA");
-	} else if (!strcmp(model, "Brocade-1867")) {
+				"QLogic BR-series 16Gbps PCIe dual port FC HBA");
+	} else if (!strcmp(model, "QLogic-1867")) {
 		if (nports == 1 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe single port FC HBA for IBM");
+				"QLogic BR-series 16Gbps PCIe single port FC HBA for IBM");
 		else if (nports == 2 && !bfa_ioc_is_cna(&bfad->bfa.ioc))
 			snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
-				"Brocade 16Gbps PCIe dual port FC HBA for IBM");
+				"QLogic BR-series 16Gbps PCIe dual port FC HBA for IBM");
 	} else
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Invalid Model");
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index b9d1460..d1ad020 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.h
index 59aca80..917e140 100644
--- a/drivers/scsi/bfa/bfad_bsg.h
+++ b/drivers/scsi/bfa/bfad_bsg.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 62b11d4..8dcd8c7 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 58fee34..8001459 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 3e4dce7..7db1542 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
@@ -186,7 +186,7 @@ bfad_im_info(struct Scsi_Host *shost)
 
 	memset(bfa_buf, 0, sizeof(bfa_buf));
 	snprintf(bfa_buf, sizeof(bfa_buf),
-		"Brocade FC/FCOE Adapter, " "hwpath: %s driver: %s",
+		"QLogic BR-series FC/FCOE Adapter, hwpath: %s driver: %s",
 		bfad->pci_name, BFAD_DRIVER_VERSION);
 
 	return bfa_buf;
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index 31434df..836fdc2 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 54c93ef..97600dc 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index 8699be4..ae5bfe0 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
diff --git a/drivers/scsi/bfa/bfi_reg.h b/drivers/scsi/bfa/bfi_reg.h
index 7d071a4..fd5b876 100644
--- a/drivers/scsi/bfa/bfi_reg.h
+++ b/drivers/scsi/bfa/bfi_reg.h
@@ -4,7 +4,7 @@
  * All rights reserved
  * www.qlogic.com
  *
- * Linux driver for Brocade Fibre Channel Host Bus Adapter.
+ * Linux driver for QLogic BR-series Fibre Channel Host Bus Adapter.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License (GPL) Version 2 as
@@ -17,7 +17,7 @@
  */
 
 /*
- * bfi_reg.h ASIC register defines for all Brocade adapter ASICs
+ * bfi_reg.h ASIC register defines for all QLogic BR-series adapter ASICs
  */
 
 #ifndef __BFI_REG_H__
-- 
1.7.1

