From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 0/4] megaraid_sas: Update for scsi for-next
Date: Mon, 30 Jun 2014 17:19:54 -0700
Message-ID: <1404173998-24363-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61596 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbaGAAVG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2014 20:21:06 -0400
Received: by mail-pd0-f173.google.com with SMTP id r10so9079362pdi.32
        for <linux-scsi@vger.kernel.org>; Mon, 30 Jun 2014 17:21:05 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

(Re-sending with git-send-email on advice of Martin Petersen @ Oracle)

James/linux-scsi,

The following patch series for megaraid_sas brings the driver up to
v06.803.02.00-rc1.

1. Fix reset_mutex leak in megasas_reset_fusion().
2. Remove unused variables in megasas_instance.
3. Fix LD/VF affiliation parsing.
4. Version and Changelog update.

Adam Radford (4):
  megaraid_sas: Fix reset_mutex leak
  megaraid_sas: Removed unused variables in megasas_instance
  megaraid_sas: Fix LD/VF affiliation parsing
  megaraid_sas: Version and Changelog update

 Documentation/scsi/ChangeLog.megaraid_sas   | 13 +++++
 drivers/scsi/megaraid/megaraid_sas.h        |  9 ++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 90 ++++++++++++++++++++---------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  1 +
 4 files changed, 82 insertions(+), 31 deletions(-)

-- 
1.7.11.7

