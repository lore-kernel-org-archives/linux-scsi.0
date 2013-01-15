From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v13 9/9] scsi: remove can_power_off flag from scsi_device
Date: Tue, 15 Jan 2013 17:21:05 +0800
Message-ID: <1358241665-2156-10-git-send-email-aaron.lu@intel.com>
References: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:9325 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704Ab3AOJUj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jan 2013 04:20:39 -0500
In-Reply-To: <1358241665-2156-1-git-send-email-aaron.lu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

Commit 166a2967b45ede2e2e56f3ede3cd32053dc17812 "libata: tell scsi layer
device supports runtime power off" introduced the can_power_off flag for
scsi_device and is used to support ZPODD implementation in SCSI layer.
Since ZPODD is now implemented in ATA layer, that flag is no longer
needed, so remove it.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 include/scsi/scsi_device.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bb1371b..a7f9cba 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -157,7 +157,6 @@ struct scsi_device {
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
 	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
-	unsigned can_power_off:1; /* Device supports runtime power off */
 	unsigned wce_default_on:1;	/* Cache is ON by default */
 	unsigned no_dif:1;	/* T10 PI (DIF) should be disabled */
 
-- 
1.7.11.7

