From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 6/8] [SCSI] scst: Fix online documentation
Date: Mon, 27 Dec 2010 14:40:16 +0100
Message-ID: <201012271440.17058.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:52306 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab0L0NkZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:40:25 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Fix an error in the online documentation of /sys/devices/scst/mgmt,
reorder it and make that documentation more consistent.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scst/scst_sysfs.c |   37 +++++++++++++++++--------------------
 1 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index 525f368..aadb066 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -3217,21 +3217,21 @@ static ssize_t scst_mgmt_show(struct device *device,
 {
 	ssize_t count;
 	static const char help[] =
-/* device/<dev>/filename */
-"in device/<dev> <dev_cmd>\n"
 /* scst_devt_mgmt or scst_devt_pass_through_mgmt */
 "in device_driver/<devt> <devt_cmd>\n"
+/* device/<dev>/filename */
+"in device/<dev> <dev_cmd>\n"
 /* scst_tgtt_mgmt */
 "in target_driver/<tgtt> <tgtt_cmd>\n"
 /* scst_tgt_mgmt */
-"in target_driver/<tgtt>/<target>/luns <tgt_cmd>\n"
+"in target_driver/<tgtt>/<target> <tgt_cmd>\n"
 /* scst_luns_mgmt */
 "in target_driver/<tgtt>/<target>/luns <luns_cmd>\n"
 /* scst_ini_group_mgmt */
 "in target_driver/<tgtt>/<target>/ini_groups <acg_mgmt_cmd>\n"
 "in target_driver/<tgtt>/<target>/ini_groups/<acg> <acg_cmd>\n"
 /* scst_acg_luns_mgmt */
-"in target_driver/<tgtt>/<target>/ini_groups/<acg>/luns <luns_cmd>\n"
+"in target_driver/<tgtt>/<target>/ini_groups/<acg>/luns <lun_cmd>\n"
 /* scst_acg_ini_mgmt */
 "in target_driver/<tgtt>/<target>/ini_groups/<acg>/initiators <acg_ini_cmd>\n"
 "\n"
@@ -3243,12 +3243,12 @@ static ssize_t scst_mgmt_show(struct device *device,
 "\n"
 "devt_cmd syntax:\n"
 "\n"
-"add_device device_name [parameters]\n"
-"del_device device_name\n"
+"add_device <device_name> [<parameters>]\n"
+"del_device <device_name>\n"
 "add_attribute <attribute> <value>\n"
 "del_attribute <attribute> <value>\n"
-"add_device_attribute device_name <attribute> <value>\n"
-"del_device_attribute device_name <attribute> <value>\n"
+"add_device_attribute <device_name> <attribute> <value>\n"
+"del_device_attribute <device_name> <attribute> <value>\n"
 "\n"
 "devt_cmd syntax for pass-through device types:\n"
 "\n"
@@ -3257,12 +3257,9 @@ static ssize_t scst_mgmt_show(struct device *device,
 "\n"
 "tgtt_cmd syntax:\n"
 "\n"
-"add_target target_name [parameters]\n"
-"del_target target_name\n"
-"add_attribute <attribute> <value>\n"
-"del_attribute <attribute> <value>\n"
-"add_target_attribute target_name <attribute> <value>\"\n"
-"del_target_attribute target_name <attribute> <value>\"\n"
+"add_target <target_name> [<parameters>]\n"
+"del_target <target_name>\n"
+"<target-driver-specific-command-and-parameters>\n"
 "\n"
 "where parameters is one or more <name>=<value> pairs separated by ';'\n"
 "\n"
@@ -3272,13 +3269,13 @@ static ssize_t scst_mgmt_show(struct device *device,
 "disable\n"
 "set_cpu_mask <mask>\n"
 "\n"
-"luns_cmd syntax:\n"
+"lun_cmd syntax:\n"
 "\n"
-"add|del H:C:I:L lun [parameters]\n"
-"add VNAME lun [parameters]\n"
-"del lun\n"
-"replace H:C:I:L lun [parameters]\n"
-"replace VNAME lun [parameters]\n"
+"add|del H:C:I:L <lun> [<parameters>]\n"
+"add <vname> <lun> [<parameters>]\n"
+"del <lun>\n"
+"replace H:C:I:L <lun> [<parameters>]\n"
+"replace <vname> <lun> [<parameters>]\n"
 "clear\n"
 "\n"
 "where parameters is either 'read_only' or empty.\n"
-- 
1.7.1

