From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] resend add scsi_level to scsi_device sysfs attributes
Date: Tue, 7 Jan 2003 16:56:59 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030107165659.A17757@beaverton.ibm.com>
References: <20030107165324.A17719@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030107165324.A17719@beaverton.ibm.com>; from patmans@us.ibm.com on Tue, Jan 07, 2003 at 04:53:24PM -0800
List-Id: linux-scsi@vger.kernel.org
To: JEJ Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

Hi -

[Resending and cc-ing linux-scsi properly.]

This simple patch adds scsi_level to the scsi_device sysfs attributes,
mainly for use with Doug Gilbert's lsscsi program.

--- 1.2/drivers/scsi/scsi_sysfs.c	Tue Dec  3 00:53:21 2002
+++ edited/drivers/scsi/scsi_sysfs.c	Mon Dec 30 14:11:10 2002
@@ -224,6 +224,7 @@
 sdev_rd_attr (current_queue_depth, "%d\n");
 sdev_rd_attr (new_queue_depth, "%d\n");
 sdev_rd_attr (type, "%d\n");
+sdev_rd_attr (scsi_level, "%d\n");
 sdev_rd_attr (access_count, "%d\n");
 sdev_rd_attr (vendor, "%.8s\n");
 sdev_rd_attr (model, "%.16s\n");
@@ -235,6 +236,7 @@
 	&dev_attr_current_queue_depth,
 	&dev_attr_new_queue_depth,
 	&dev_attr_type,
+	&dev_attr_scsi_level,
 	&dev_attr_access_count,
 	&dev_attr_vendor,
 	&dev_attr_model,

-- Patrick Mansfield
