From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 0/2] Migrate SCSI drivers to use dev_pm_ops
Date: Wed, 10 Oct 2012 15:28:04 +0800
Message-ID: <1349854086-2502-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:11520 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab2JJH22 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Oct 2012 03:28:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

The 2 patches will migrate SCSI drivers to use the pm callbacks defined
in dev_pm_ops as pm_message is deprecated and should not be used by driver.
Bus level callback is changed to use callbacks defined in dev_pm_ops when
needed and sd's pm callback is updated to use what are defined in dev_pm_ops.

Aaron Lu (2):
  [SCSI] pm: use callbacks from dev_pm_ops for scsi devices
  [SCSI] sd: update sd to use the new pm callbacks

 drivers/scsi/scsi_pm.c | 85 +++++++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/sd.c      | 18 ++++++++---
 2 files changed, 79 insertions(+), 24 deletions(-)

-- 
1.7.12.21.g871e293

