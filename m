From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 0/4] megaraid_sas: Updates for scsi-next
Date: Fri, 15 Apr 2016 00:23:29 -0700
Message-ID: <1460705013-6482-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f181.google.com ([209.85.192.181]:35233 "EHLO
	mail-pf0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbcDOHXs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 03:23:48 -0400
Received: by mail-pf0-f181.google.com with SMTP id n1so54388809pfn.2
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2016 00:23:47 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, hch@infradead.org, thenzl@redhat.com
Cc: kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org, sumit.saxena@broadcom.com

This patchset has few small fixes/optimizations. Please consider this
for next release.

Sumit Saxena (4):
  megaraid_sas: reduce memory footprints in kdump mode
  megaraid_sas: call ISR function to clean up pending replies in OCR
    path
  megaraid_sas: task management code optimizations
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |   6 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 115 ++++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   5 ++
 3 files changed, 84 insertions(+), 42 deletions(-)

-- 
2.4.11

