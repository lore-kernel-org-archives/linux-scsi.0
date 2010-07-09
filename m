From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 19/24] bfa: add description for module parameters
Date: Thu, 8 Jul 2010 19:59:49 -0700
Message-ID: <1278644389-3079-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-000f0801.pphosted.com ([67.231.152.113]:55878 "EHLO
	mx0b-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095Ab0GIC7z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 22:59:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: kgudipat@brocade.com, vravindr@brocade.com, rvadivel@brocade.com, amathur@brocade.com, Jing Huang <huangj@brocade.com>

Add description for bfa driver module parameters.

Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfad.c      |   33 ++++++++++++++++++++++++++++++---
 drivers/scsi/bfa/bfad_intr.c |    4 ++++
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 37f886d..a17800e 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -54,31 +54,58 @@ static int      bfa_io_max_sge = BFAD_IO_MAX_SGE;
 static int      log_level = BFA_LOG_WARNING;
 static int      ioc_auto_recover = BFA_TRUE;
 static int      ipfc_enable = BFA_FALSE;
-static int      ipfc_mtu = -1;
 static int	fdmi_enable = BFA_TRUE;
 int 		bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
 int      	bfa_linkup_delay = -1;
 
 module_param(os_name, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(os_name, "OS name of the hba host machine");
 module_param(os_patch, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(os_patch, "OS patch level of the hba host machine");
 module_param(host_name, charp, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(host_name, "Hostname of the hba host machine");
 module_param(num_rports, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_rports, "Max number of rports supported per port"
+		" (physical/logical), default=1024");
 module_param(num_ios, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_ios, "Max number of ioim requests, default=2000");
 module_param(num_tms, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_tms, "Max number of task im requests, default=128");
 module_param(num_fcxps, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_fcxps, "Max number of fcxp requests, default=64");
 module_param(num_ufbufs, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_ufbufs, "Max number of unsolicited frame buffers,"
+		" default=64");
 module_param(reqq_size, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(reqq_size, "Max number of request queue elements,"
+		" default=256");
 module_param(rspq_size, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rspq_size, "Max number of response queue elements,"
+		" default=64");
 module_param(num_sgpgs, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(num_sgpgs, "Number of scatter/gather pages, default=2048");
 module_param(rport_del_timeout, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(rport_del_timeout, "Rport delete timeout, default=90 secs,"
+		" Range[>0]");
 module_param(bfa_lun_queue_depth, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_lun_queue_depth, "Lun queue depth, default=32,"
+		" Range[>0]");
 module_param(bfa_io_max_sge, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_io_max_sge, "Max io scatter/gather elements, default=255");
 module_param(log_level, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(log_level, "Driver log level, default=3,"
+		" Range[Critical:1|Error:2|Warning:3|Info:4]");
 module_param(ioc_auto_recover, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ioc_auto_recover, "IOC auto recovery, default=1,"
+		" Range[off:0|on:1]");
 module_param(ipfc_enable, int, S_IRUGO | S_IWUSR);
-module_param(ipfc_mtu, int, S_IRUGO | S_IWUSR);
-module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(ipfc_enable, "Enable IPoFC, default=0, Range[off:0|on:1]");
 module_param(bfa_linkup_delay, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(bfa_linkup_delay, "Link up delay, default=30 secs for boot"
+		" port. Otherwise Range[>0]");
+module_param(fdmi_enable, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(fdmi_enable, "Enables fdmi registration, default=1,"
+		" Range[false:0|true:1]");
 
 /*
  * Stores the module parm num_sgpgs value;
diff --git a/drivers/scsi/bfa/bfad_intr.c b/drivers/scsi/bfa/bfad_intr.c
index fed27d1..56a3515 100644
--- a/drivers/scsi/bfa/bfad_intr.c
+++ b/drivers/scsi/bfa/bfad_intr.c
@@ -26,7 +26,11 @@ BFA_TRC_FILE(LDRV, INTR);
 static int msix_disable_cb;
 static int msix_disable_ct;
 module_param(msix_disable_cb, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(msix_disable_cb, "Disable MSIX for Brocade-415/425/815/825"
+		" cards, default=0, Range[false:0|true:1]");
 module_param(msix_disable_ct, int, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(msix_disable_ct, "Disable MSIX for Brocade-1010/1020/804"
+		" cards, default=0, Range[false:0|true:1]");
 /**
  * Line based interrupt handler.
  */
-- 
1.6.5.2

