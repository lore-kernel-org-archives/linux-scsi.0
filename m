From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 0/2] megaraid_sas: few more updates for scsi-next
Date: Thu, 28 Jan 2016 21:14:24 +0530
Message-ID: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:36488 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933444AbcA1Poq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:44:46 -0500
Received: by mail-pa0-f50.google.com with SMTP id yy13so24873129pab.3
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:44:46 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

These two patches will be applied on top of recent resent patchset by me.
I am posting these patches separately(not in the resent patchset) to avoid confusion
as these are fresh(first time) submitted.

Sumit Saxena (2):
  megaraid_sas: Fix for IO failing post OCR in SRIOV environment
  megaraid_sas: Fix SMAP issue

 drivers/scsi/megaraid/megaraid_sas.h        | 13 ++++++---
 drivers/scsi/megaraid/megaraid_sas_base.c   | 19 ++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 42 ++++++++++++++++++-----------
 3 files changed, 45 insertions(+), 29 deletions(-)

-- 
1.8.3.1

