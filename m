From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 0/3] may_power_off for scsi device
Date: Thu, 30 Aug 2012 14:43:57 +0800
Message-ID: <1346309040-27112-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58762 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab2H3Goe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Aug 2012 02:44:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>
Cc: linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>, Aaron Lu <aaron.lu@intel.com>

Add a new flag may_power_off for scsi device to let user control when
it is runtime suspended, can we remove its power.

This patchset makes the following patch sent previously deprecated:
[PATCH] scsi: sr: add may_power_off flag
http://marc.info/?l=linux-scsi&m=134614323832520&w=2

The patch "scsi: pm: add may_power_off flag" also appears in another
patchset intended for libata due to libata will use this flag to
decide if ACPI D3cold can be used. They two patches are identical.

Based on top of the previously sent v4 ZPODD patchset:
https://lkml.org/lkml/2012/7/27/71

Aaron Lu (3):
  scsi: pm: add may_power_off flag
  scsi: sr: use may_power_off to enable/disable ZPODD
  scsi: sd: add may_power_off sysfs entry

 drivers/scsi/sd.c          | 34 ++++++++++++++++++++++++++++
 drivers/scsi/sr.c          | 55 +++++++++++++++++++++++++++++++++++++++++-----
 include/scsi/scsi_device.h |  1 +
 3 files changed, 84 insertions(+), 6 deletions(-)

-- 
1.7.11.5

