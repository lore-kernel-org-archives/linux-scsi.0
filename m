From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: PATCH [5/18]  qla2xxx: Add module parameter permissions
Date: Mon, 21 Jun 2004 22:52:02 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040622055202.GA8418@linux.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:9161 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266593AbUFVFsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jun 2004 01:48:18 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>

ChangeSet
  1.1841 04/06/03 16:29:07 andrew.vasquez@apc.qlogic.com +1 -0
  Add permissions to the driver's module_params.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

 drivers/scsi/qla2xxx/qla_os.c |   24 ++++++++++++------------
 1 files changed, 12 insertions(+), 12 deletions(-)

diff -Nru a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
--- a/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:37:25 -07:00
+++ b/drivers/scsi/qla2xxx/qla_os.c	2004-06-21 15:37:25 -07:00
@@ -46,72 +46,72 @@
  * Module parameter information and variables
  */
 int ql2xmaxqdepth;
-module_param(ql2xmaxqdepth, int, 0);
+module_param(ql2xmaxqdepth, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to report for target devices.");
 
 int ql2xlogintimeout = 20;
-module_param(ql2xlogintimeout, int, 0);
+module_param(ql2xlogintimeout, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xlogintimeout,
 		"Login timeout value in seconds.");
 
 int qlport_down_retry;
-module_param(qlport_down_retry, int, 0);
+module_param(qlport_down_retry, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(qlport_down_retry,
 		"Maximum number of command retries to a port that returns"
 		"a PORT-DOWN status.");
 
 int ql2xretrycount = 20;
-module_param(ql2xretrycount, int, 0);
+module_param(ql2xretrycount, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xretrycount,
 		"Maximum number of mid-layer retries allowed for a command.  "
 		"Default value is 20, ");
 
 int displayConfig;
-module_param(displayConfig, int, 0);
+module_param(displayConfig, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(displayConfig,
 		"If 1 then display the configuration used in /etc/modprobe.conf.");
 
 int ql2xplogiabsentdevice;
-module_param(ql2xplogiabsentdevice, int, 0);
+module_param(ql2xplogiabsentdevice, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"Option to enable PLOGI to devices that are not present after "
 		"a Fabric scan.  This is needed for several broken switches."
 		"Default is 0 - no PLOGI. 1 - perfom PLOGI.");
 
 int ql2xintrdelaytimer = 10;
-module_param(ql2xintrdelaytimer, int, 0);
+module_param(ql2xintrdelaytimer, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xintrdelaytimer,
 		"ZIO: Waiting time for Firmware before it generates an "
 		"interrupt to the host to notify completion of request.");
 
 int ConfigRequired;
-module_param(ConfigRequired, int, 0);
+module_param(ConfigRequired, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ConfigRequired,
 		"If 1, then only configured devices passed in through the"
 		"ql2xopts parameter will be presented to the OS");
 
 int Bind = BIND_BY_PORT_NAME;
-module_param(Bind, int, 0);
+module_param(Bind, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(Bind,
 		"Target persistent binding method: "
 		"0 by Portname (default); 1 by PortID; 2 by Nodename. ");
 
 int ql2xsuspendcount = SUSPEND_COUNT;
-module_param(ql2xsuspendcount, int, 0);
+module_param(ql2xsuspendcount, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xsuspendcount,
 		"Number of 6-second suspend iterations to perform while a "
 		"target returns a <NOT READY> status.  Default is 10 "
 		"iterations.");
 
 int ql2xdoinitscan = 1;
-module_param(ql2xdoinitscan, int, 0);
+module_param(ql2xdoinitscan, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(ql2xdoinitscan,
 		"Signal mid-layer to perform scan after driver load: 0 -- no "
 		"signal sent to mid-layer.");
 
 int ql2xloginretrycount = 0;
-module_param(ql2xloginretrycount, int, 0);
+module_param(ql2xloginretrycount, int, S_IRUGO|S_IRUSR);
 MODULE_PARM_DESC(ql2xloginretrycount,
 		"Specify an alternate value for the NVRAM login retry count.");
 
