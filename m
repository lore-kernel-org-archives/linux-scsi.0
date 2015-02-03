From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH RESEND 1/4] bfa:Updating copyright messages
Date: Tue, 3 Feb 2015 03:45:00 -0500
Message-ID: <1422953103-5470-2-git-send-email-anil.gurumurthy@qlogic.com>
References: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:64397 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754828AbbBCJYl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 04:24:41 -0500
In-Reply-To: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfa.h           |    5 +++--
 drivers/scsi/bfa/bfa_core.c      |    5 +++--
 drivers/scsi/bfa/bfa_cs.h        |    5 +++--
 drivers/scsi/bfa/bfa_defs.h      |    5 +++--
 drivers/scsi/bfa/bfa_defs_fcs.h  |    5 +++--
 drivers/scsi/bfa/bfa_defs_svc.h  |    5 +++--
 drivers/scsi/bfa/bfa_fc.h        |    5 +++--
 drivers/scsi/bfa/bfa_fcbuild.c   |    5 +++--
 drivers/scsi/bfa/bfa_fcbuild.h   |    5 +++--
 drivers/scsi/bfa/bfa_fcpim.c     |    5 +++--
 drivers/scsi/bfa/bfa_fcpim.h     |    5 +++--
 drivers/scsi/bfa/bfa_fcs.c       |    5 +++--
 drivers/scsi/bfa/bfa_fcs.h       |    5 +++--
 drivers/scsi/bfa/bfa_fcs_fcpim.c |    5 +++--
 drivers/scsi/bfa/bfa_fcs_lport.c |    5 +++--
 drivers/scsi/bfa/bfa_fcs_rport.c |    5 +++--
 drivers/scsi/bfa/bfa_hw_cb.c     |    5 +++--
 drivers/scsi/bfa/bfa_hw_ct.c     |    5 +++--
 drivers/scsi/bfa/bfa_ioc.c       |    5 +++--
 drivers/scsi/bfa/bfa_ioc.h       |    5 +++--
 drivers/scsi/bfa/bfa_ioc_cb.c    |    5 +++--
 drivers/scsi/bfa/bfa_ioc_ct.c    |    5 +++--
 drivers/scsi/bfa/bfa_modules.h   |    5 +++--
 drivers/scsi/bfa/bfa_plog.h      |    5 +++--
 drivers/scsi/bfa/bfa_port.c      |    5 +++--
 drivers/scsi/bfa/bfa_port.h      |    5 +++--
 drivers/scsi/bfa/bfa_svc.c       |    5 +++--
 drivers/scsi/bfa/bfa_svc.h       |    5 +++--
 drivers/scsi/bfa/bfad.c          |    5 +++--
 drivers/scsi/bfa/bfad_attr.c     |    5 +++--
 drivers/scsi/bfa/bfad_bsg.c      |    5 +++--
 drivers/scsi/bfa/bfad_bsg.h      |    5 +++--
 drivers/scsi/bfa/bfad_debugfs.c  |    5 +++--
 drivers/scsi/bfa/bfad_drv.h      |    5 +++--
 drivers/scsi/bfa/bfad_im.c       |    5 +++--
 drivers/scsi/bfa/bfad_im.h       |    5 +++--
 drivers/scsi/bfa/bfi.h           |    5 +++--
 drivers/scsi/bfa/bfi_ms.h        |    5 +++--
 drivers/scsi/bfa/bfi_reg.h       |    5 +++--
 39 files changed, 117 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/bfa/bfa.h b/drivers/scsi/bfa/bfa.h
index 4ad7e36..7d0337b 100644
--- a/drivers/scsi/bfa/bfa.h
+++ b/drivers/scsi/bfa/bfa.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_core.c b/drivers/scsi/bfa/bfa_core.c
index e3f67b0..f157a37 100644
--- a/drivers/scsi/bfa/bfa_core.c
+++ b/drivers/scsi/bfa/bfa_core.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_cs.h b/drivers/scsi/bfa/bfa_cs.h
index 91a8aa3..c8bb20a 100644
--- a/drivers/scsi/bfa/bfa_cs.h
+++ b/drivers/scsi/bfa/bfa_cs.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_defs.h b/drivers/scsi/bfa/bfa_defs.h
index 877b86d..da4f705 100644
--- a/drivers/scsi/bfa/bfa_defs.h
+++ b/drivers/scsi/bfa/bfa_defs.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_defs_fcs.h b/drivers/scsi/bfa/bfa_defs_fcs.h
index 06f0a16..5185ae3 100644
--- a/drivers/scsi/bfa/bfa_defs_fcs.h
+++ b/drivers/scsi/bfa/bfa_defs_fcs.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_defs_svc.h b/drivers/scsi/bfa/bfa_defs_svc.h
index 638f441..fd2fa24 100644
--- a/drivers/scsi/bfa/bfa_defs_svc.h
+++ b/drivers/scsi/bfa/bfa_defs_svc.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fc.h b/drivers/scsi/bfa/bfa_fc.h
index 64069a0..7142309 100644
--- a/drivers/scsi/bfa/bfa_fc.h
+++ b/drivers/scsi/bfa/bfa_fc.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcbuild.c b/drivers/scsi/bfa/bfa_fcbuild.c
index dce787f..6f670d3 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.c
+++ b/drivers/scsi/bfa/bfa_fcbuild.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcbuild.h b/drivers/scsi/bfa/bfa_fcbuild.h
index 03c753d..85e3c58 100644
--- a/drivers/scsi/bfa/bfa_fcbuild.h
+++ b/drivers/scsi/bfa/bfa_fcbuild.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcpim.c b/drivers/scsi/bfa/bfa_fcpim.c
index d7385d1..3881a72 100644
--- a/drivers/scsi/bfa/bfa_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcpim.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcpim.h b/drivers/scsi/bfa/bfa_fcpim.h
index e693af6..0c37062 100644
--- a/drivers/scsi/bfa/bfa_fcpim.h
+++ b/drivers/scsi/bfa/bfa_fcpim.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 0f19455..043d3c0 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 42bcb97..30b4555 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcs_fcpim.c b/drivers/scsi/bfa/bfa_fcs_fcpim.c
index 6dc7926..4fd20d9 100644
--- a/drivers/scsi/bfa/bfa_fcs_fcpim.c
+++ b/drivers/scsi/bfa/bfa_fcs_fcpim.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index ff75ef8..d823792 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 2035b0d..5559faa 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_hw_cb.c b/drivers/scsi/bfa/bfa_hw_cb.c
index ea24d4c..e3648d9 100644
--- a/drivers/scsi/bfa/bfa_hw_cb.c
+++ b/drivers/scsi/bfa/bfa_hw_cb.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_hw_ct.c b/drivers/scsi/bfa/bfa_hw_ct.c
index 637527f..f19bc44 100644
--- a/drivers/scsi/bfa/bfa_hw_ct.c
+++ b/drivers/scsi/bfa/bfa_hw_ct.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index 315d6d6..f9856b1 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index a38aafa..0d6e165 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index 453c2f5..10a0042 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index bd53150..1e5fa61 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index a14c784..5b02415 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_plog.h b/drivers/scsi/bfa/bfa_plog.h
index 1c9baa6..4fdba6f 100644
--- a/drivers/scsi/bfa/bfa_plog.h
+++ b/drivers/scsi/bfa/bfa_plog.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_port.c b/drivers/scsi/bfa/bfa_port.c
index 8ea7697..314548a 100644
--- a/drivers/scsi/bfa/bfa_port.c
+++ b/drivers/scsi/bfa/bfa_port.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_port.h b/drivers/scsi/bfa/bfa_port.h
index 2fcab6b..ba715ce 100644
--- a/drivers/scsi/bfa/bfa_port.h
+++ b/drivers/scsi/bfa/bfa_port.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 625225f..93e588f 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfa_svc.h b/drivers/scsi/bfa/bfa_svc.h
index ef07365..efb0497 100644
--- a/drivers/scsi/bfa/bfa_svc.h
+++ b/drivers/scsi/bfa/bfa_svc.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index e90a374..81d8ff6 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 40be670..66cca48 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 023b9d4..b9d1460 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_bsg.h b/drivers/scsi/bfa/bfad_bsg.h
index 90abef6..59aca80 100644
--- a/drivers/scsi/bfa/bfad_bsg.h
+++ b/drivers/scsi/bfa/bfad_bsg.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_debugfs.c b/drivers/scsi/bfa/bfad_debugfs.c
index 74a307c..62b11d4 100644
--- a/drivers/scsi/bfa/bfad_debugfs.c
+++ b/drivers/scsi/bfa/bfad_debugfs.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 8b97877..58fee34 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 7223b00..575efdc 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfad_im.h b/drivers/scsi/bfa/bfad_im.h
index f6c1023..31434df 100644
--- a/drivers/scsi/bfa/bfad_im.h
+++ b/drivers/scsi/bfa/bfad_im.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfi.h b/drivers/scsi/bfa/bfi.h
index 9ef91f9..54c93ef 100644
--- a/drivers/scsi/bfa/bfi.h
+++ b/drivers/scsi/bfa/bfi.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
index 1a3fe5a..8699be4 100644
--- a/drivers/scsi/bfa/bfi_ms.h
+++ b/drivers/scsi/bfa/bfi_ms.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
diff --git a/drivers/scsi/bfa/bfi_reg.h b/drivers/scsi/bfa/bfi_reg.h
index 99133bc..7d071a4 100644
--- a/drivers/scsi/bfa/bfi_reg.h
+++ b/drivers/scsi/bfa/bfi_reg.h
@@ -1,7 +1,8 @@
 /*
- * Copyright (c) 2005-2010 Brocade Communications Systems, Inc.
+ * Copyright (c) 2005-2014 Brocade Communications Systems, Inc.
+ * Copyright (c) 2014- QLogic Corporation.
  * All rights reserved
- * www.brocade.com
+ * www.qlogic.com
  *
  * Linux driver for Brocade Fibre Channel Host Bus Adapter.
  *
-- 
1.7.1

