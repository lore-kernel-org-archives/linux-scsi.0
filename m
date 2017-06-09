From: <gregkh@linuxfoundation.org>
Subject: patch "scsi: ibmvscsi_tgt: remove use of class_attrs" added to driver-core-testing
Date: Fri, 09 Jun 2017 10:41:17 +0200
Message-ID: <1496997677180106@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, bryantly@linux.vnet.ibm.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, mikecyr@linux.vnet.ibm.com, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    scsi: ibmvscsi_tgt: remove use of class_attrs

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-testing branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will be merged to the driver-core-next branch sometime soon,
after it passes testing, and the merge window is open.

If you have any questions about this process, please let me know.


>From f62014fcb9e4af6267dce6e3bf5dc40fdc58f255 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 8 Jun 2017 10:12:37 +0200
Subject: scsi: ibmvscsi_tgt: remove use of class_attrs

The class_attrs pointer is going away and it's not even being used in
this driver, so just remove it entirely.

Acked-by: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: <linux-scsi@vger.kernel.org>
Cc: <target-devel@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
index d390325c99ec..b480878e3258 100644
--- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
+++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
@@ -3915,10 +3915,6 @@ static const struct target_core_fabric_ops ibmvscsis_ops = {
 
 static void ibmvscsis_dev_release(struct device *dev) {};
 
-static struct class_attribute ibmvscsis_class_attrs[] = {
-	__ATTR_NULL,
-};
-
 static struct device_attribute dev_attr_system_id =
 	__ATTR(system_id, S_IRUGO, system_id_show, NULL);
 
@@ -3938,7 +3934,6 @@ ATTRIBUTE_GROUPS(ibmvscsis_dev);
 static struct class ibmvscsis_class = {
 	.name		= "ibmvscsis",
 	.dev_release	= ibmvscsis_dev_release,
-	.class_attrs	= ibmvscsis_class_attrs,
 	.dev_groups	= ibmvscsis_dev_groups,
 };
 
-- 
2.13.1
