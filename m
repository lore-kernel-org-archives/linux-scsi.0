From: Neerav Parikh <neerav.parikh@intel.com>
Subject: [PATCH 6/6] fcoe: Allow exposing FDMI attributes via sysfs
Date: Sun, 22 Jan 2012 17:30:16 -0800
Message-ID: <20120123013016.923.18967.stgit@localhost6.localdomain6>
References: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7879 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528Ab2AWBl3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Jan 2012 20:41:29 -0500
In-Reply-To: <20120123012944.923.63220.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, james.smart@emulex.com, devel@open-fcoe.org

Allow FDMI attributes to be exposed via the fc_host
class object for the fcoe driver.

Signed-off-by: Neerav Parikh <neerav.parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Acked-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index b222e2d..5e77f23 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -168,6 +168,14 @@ static struct fc_function_template fcoe_nport_fc_functions = {
 	.show_host_supported_fc4s = 1,
 	.show_host_active_fc4s = 1,
 	.show_host_maxframe_size = 1,
+	.show_host_serial_number = 1,
+	.show_host_manufacturer = 1,
+	.show_host_model = 1,
+	.show_host_model_description = 1,
+	.show_host_hardware_version = 1,
+	.show_host_driver_version = 1,
+	.show_host_firmware_version = 1,
+	.show_host_optionrom_version = 1,
 
 	.show_host_port_id = 1,
 	.show_host_supported_speeds = 1,

