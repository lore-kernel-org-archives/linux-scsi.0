From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 8/8] bfa: makefile update
Date: Sun, 29 Nov 2009 17:45:12 -0800
Message-ID: <1259545512-5308-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:36890 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbZK3BpH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 29 Nov 2009 20:45:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Updates to the Makefile.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index 1d60094..619e62a 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -2,8 +2,8 @@ obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 
 bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
 
-bfa-y += bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_lps.o
-bfa-y += bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
+bfa-y += bfa_core.o bfa_ioc.o bfa_ioc_ct.o bfa_ioc_cb.o bfa_iocfc.o bfa_fcxp.o
+bfa-y += bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o 
 bfa-y += bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o
 bfa-y += bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o
 bfa-y += bfa_csdebug.o bfa_sm.o plog.o
@@ -12,4 +12,4 @@ bfa-y += fcbuild.o fabric.o fcpim.o vfapi.o fcptm.o bfa_fcs.o bfa_fcs_port.o
 bfa-y += bfa_fcs_uf.o bfa_fcs_lport.o fab.o fdmi.o ms.o ns.o scn.o loop.o
 bfa-y += lport_api.o n2n.o rport.o rport_api.o rport_ftrs.o vport.o
 
-ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna
+ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna -DBFA_PERF_BUILD
-- 
1.6.5.2

