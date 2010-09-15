From: <kgudipat@brocade.com>
Subject: [PATCH 33/33] bfa: Update to (2.3.2.0) Makefile changes.
Date: Wed, 15 Sep 2010 12:18:25 -0700
Message-ID: <1284578305-22924-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:57705 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753651Ab0IOTTP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2010 15:19:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: huangj@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, adapter_linux_open_src_team@brocade.com, Krishna Gudipati <kgudipat@brocade.com>

From: Krishna Gudipati <kgudipat@brocade.com>

Change details:
	- Makefile changes due to BFA cleanup.

Signed-off-by: Krishna Gudipati <kgudipat@brocade.com>
---
 drivers/scsi/bfa/Makefile |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/bfa/Makefile b/drivers/scsi/bfa/Makefile
index ac3fdf0..d2eefd3 100644
--- a/drivers/scsi/bfa/Makefile
+++ b/drivers/scsi/bfa/Makefile
@@ -1,15 +1,8 @@
 obj-$(CONFIG_SCSI_BFA_FC) := bfa.o
 
-bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o
-bfa-y += bfad_debugfs.o
-bfa-y += bfa_core.o bfa_ioc.o bfa_ioc_ct.o bfa_ioc_cb.o bfa_iocfc.o bfa_fcxp.o
-bfa-y += bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_intr.o bfa_timer.o bfa_rport.o
-bfa-y += bfa_fcport.o bfa_port.o bfa_uf.o bfa_sgpg.o bfa_module.o bfa_ioim.o
-bfa-y += bfa_itnim.o bfa_fcpim.o bfa_tskim.o bfa_log.o bfa_log_module.o
-bfa-y += bfa_csdebug.o bfa_sm.o plog.o
+bfa-y := bfad.o bfad_im.o bfad_attr.o bfad_debugfs.o
+bfa-y += bfa_ioc.o bfa_ioc_cb.o bfa_ioc_ct.o bfa_hw_cb.o bfa_hw_ct.o
+bfa-y += bfa_fcs.o bfa_fcs_lport.o bfa_fcs_rport.o bfa_fcs_fcpim.o bfa_fcbuild.o
+bfa-y += bfa_port.o bfa_fcpim.o bfa_core.o bfa_drv.o bfa_svc.o
 
-bfa-y += fcbuild.o fabric.o fcpim.o vfapi.o fcptm.o bfa_fcs.o bfa_fcs_port.o
-bfa-y += bfa_fcs_uf.o bfa_fcs_lport.o fab.o fdmi.o ms.o ns.o scn.o loop.o
-bfa-y += lport_api.o n2n.o rport.o rport_api.o rport_ftrs.o vport.o
-
-ccflags-y := -I$(obj) -I$(obj)/include -I$(obj)/include/cna -DBFA_PERF_BUILD
+ccflags-y := -DBFA_PERF_BUILD
-- 
1.7.3.rc1

