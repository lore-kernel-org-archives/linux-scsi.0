From: Adam Radford <aradford@gmail.com>
Subject: [PATCH 0/5] megaraid_sas: Update for scsi for-next
Date: Wed,  9 Jul 2014 15:17:53 -0700
Message-ID: <1404944278-11535-1-git-send-email-aradford@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:41080 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaGIWTR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jul 2014 18:19:17 -0400
Received: by mail-pd0-f175.google.com with SMTP id v10so9644149pde.20
        for <linux-scsi@vger.kernel.org>; Wed, 09 Jul 2014 15:19:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, uday.lingala@avagotech.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com
Cc: Adam Radford <aradford@gmail.com>

(Re-sending again based on feedback from Christoph Hellwig & Martin Petersen)

The following patch series for megaraid_sas brings the driver up to
v06.803.02.00-rc1.

1. Fix reset_mutex leak in megasas_reset_fusion().
2. Remove unused variables in megasas_instance.
3. Fix LD/VF affiliation parsing.
4. Add missing initial call to megasas_get_ld_vf_affiliation().
5. Version and Changelog update.

Adam Radford (5):
  megaraid_sas: Fix reset_mutex leak
  megaraid_sas: Remove unused variables in megasas_instance
  megaraid_sas: Fix LD/VF affiliation parsing
  megaraid_sas: Add missing initial call to
    megasas_get_ld_vf_affiliation().
  megaraid_sas: Version and Changelog update

 Documentation/scsi/ChangeLog.megaraid_sas   |  14 ++
 drivers/scsi/megaraid/megaraid_sas.h        |   9 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 324 ++++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   1 +
 4 files changed, 231 insertions(+), 117 deletions(-)

-- 
1.7.11.7

