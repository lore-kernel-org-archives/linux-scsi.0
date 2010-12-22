From: madhu.iyengar@qlogic.com
Subject: [PATCH 09/14] qla2xxx: Remove redundant module parameter permission bits
Date: Tue, 21 Dec 2010 16:00:22 -0800
Message-ID: <1292976027-12034-10-git-send-email-madhu.iyengar@qlogic.com>
References: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36168 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753952Ab0LVADZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:25 -0500
In-Reply-To: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Joe Carnuccio <joe.carnuccio@qlogic.com>

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

For driver module parameters that have permission bits set to
(S_IRUGO|S_IRUSR), remove the second term since it is already
included in the first term.

S_IRUGO comes defined as (S_IRUSR|S_IRGRP|S_IROTH).

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 1814df8..51e944f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -37,12 +37,12 @@ static struct kmem_cache *srb_cachep;
 static struct kmem_cache *ctx_cachep;
 
 int ql2xlogintimeout = 20;
-module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
+module_param(ql2xlogintimeout, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xlogintimeout,
 		"Login timeout value in seconds.");
 
 int qlport_down_retry;
-module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
+module_param(qlport_down_retry, int, S_IRUGO);
 MODULE_PARM_DESC(qlport_down_retry,
 		"Maximum number of command retries to a port that returns "
 		"a PORT-DOWN status.");
@@ -55,12 +55,12 @@ MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
 
 int ql2xloginretrycount = 0;
-module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
+module_param(ql2xloginretrycount, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
 int ql2xallocfwdump = 1;
-module_param(ql2xallocfwdump, int, S_IRUGO|S_IRUSR);
+module_param(ql2xallocfwdump, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xallocfwdump,
 		"Option to enable allocation of memory for a firmware dump "
 		"during HBA initialization.  Memory allocation requirements "
@@ -73,7 +73,7 @@ MODULE_PARM_DESC(ql2xextended_error_logging,
 		"Default is 0 - no logging. 1 - log errors.");
 
 int ql2xshiftctondsd = 6;
-module_param(ql2xshiftctondsd, int, S_IRUGO|S_IRUSR);
+module_param(ql2xshiftctondsd, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xshiftctondsd,
 		"Set to control shifting of command type processing "
 		"based on total number of SG elements.");
@@ -81,7 +81,7 @@ MODULE_PARM_DESC(ql2xshiftctondsd,
 static void qla2x00_free_device(scsi_qla_host_t *);
 
 int ql2xfdmienable=1;
-module_param(ql2xfdmienable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xfdmienable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xfdmienable,
 		"Enables FDMI registrations. "
 		"0 - no FDMI. Default is 1 - perform FDMI.");
@@ -106,27 +106,27 @@ MODULE_PARM_DESC(ql2xenablehba_err_chk,
 		" Default is 0 - Error isolation disabled, 1 - Enable it");
 
 int ql2xiidmaenable=1;
-module_param(ql2xiidmaenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xiidmaenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xiidmaenable,
 		"Enables iIDMA settings "
 		"Default is 1 - perform iIDMA. 0 - no iIDMA.");
 
 int ql2xmaxqueues = 1;
-module_param(ql2xmaxqueues, int, S_IRUGO|S_IRUSR);
+module_param(ql2xmaxqueues, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xmaxqueues,
 		"Enables MQ settings "
 		"Default is 1 for single queue. Set it to number "
 		"of queues in MQ mode.");
 
 int ql2xmultique_tag;
-module_param(ql2xmultique_tag, int, S_IRUGO|S_IRUSR);
+module_param(ql2xmultique_tag, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xmultique_tag,
 		"Enables CPU affinity settings for the driver "
 		"Default is 0 for no affinity of request and response IO. "
 		"Set it to 1 to turn on the cpu affinity.");
 
 int ql2xfwloadbin;
-module_param(ql2xfwloadbin, int, S_IRUGO|S_IRUSR);
+module_param(ql2xfwloadbin, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xfwloadbin,
 		"Option to specify location from which to load ISP firmware:\n"
 		" 2 -- load firmware via the request_firmware() (hotplug)\n"
@@ -135,39 +135,39 @@ MODULE_PARM_DESC(ql2xfwloadbin,
 		" 0 -- use default semantics.\n");
 
 int ql2xetsenable;
-module_param(ql2xetsenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xetsenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xetsenable,
 		"Enables firmware ETS burst."
 		"Default is 0 - skip ETS enablement.");
 
 int ql2xdbwr = 1;
-module_param(ql2xdbwr, int, S_IRUGO|S_IRUSR);
+module_param(ql2xdbwr, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xdbwr,
 	"Option to specify scheme for request queue posting\n"
 	" 0 -- Regular doorbell.\n"
 	" 1 -- CAMRAM doorbell (faster).\n");
 
 int ql2xdontresethba;
-module_param(ql2xdontresethba, int, S_IRUGO|S_IRUSR);
+module_param(ql2xdontresethba, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xdontresethba,
 	"Option to specify reset behaviour\n"
 	" 0 (Default) -- Reset on failure.\n"
 	" 1 -- Do not reset on failure.\n");
 
 int ql2xtargetreset = 1;
-module_param(ql2xtargetreset, int, S_IRUGO|S_IRUSR);
+module_param(ql2xtargetreset, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xtargetreset,
 		 "Enable target reset."
 		 "Default is 1 - use hw defaults.");
 
 int ql2xgffidenable;
-module_param(ql2xgffidenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xgffidenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xgffidenable,
 		"Enables GFF_ID checks of port type. "
 		"Default is 0 - Do not use GFF_ID information.");
 
 int ql2xasynctmfenable;
-module_param(ql2xasynctmfenable, int, S_IRUGO|S_IRUSR);
+module_param(ql2xasynctmfenable, int, S_IRUGO);
 MODULE_PARM_DESC(ql2xasynctmfenable,
 		"Enables issue of TM IOCBs asynchronously via IOCB mechanism"
 		"Default is 0 - Issue TM IOCBs via mailbox mechanism.");
-- 
1.6.0.2

