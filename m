From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 07/12] fcoe: Allow exposing FDMI attributes via sysfs
Date: Fri, 10 Feb 2012 17:18:31 -0800
Message-ID: <20120211011831.7668.45475.stgit@localhost6.localdomain6>
References: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58837 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758601Ab2BKBSb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2012 20:18:31 -0500
In-Reply-To: <20120211011754.7668.51489.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Ross Brattain <ross.b.brattain@intel.com>, Neerav Parikh <neerav.parikh@intel.com>

From: Neerav Parikh <neerav.parikh@intel.com>

Allow FDMI attributes to be exposed via the fc_host
class object for the fcoe driver.

Signed-off-by: Neerav Parikh <neerav.parikh@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Acked-by: Robert Love <robert.w.love@intel.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
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

