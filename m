From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 00/15] megaraid_sas: Updates for scsi-next
Date: Fri, 18 Dec 2015 18:56:53 +0530
Message-ID: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33168 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbbLRNfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 08:35:41 -0500
Received: by mail-pf0-f182.google.com with SMTP id n128so31602179pfn.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 05:35:41 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Sumit Saxena (15):
  megaraid_sas: Do not allow PCI access during OCR
  megaraid_sas: MFI IO timeout handling
  megaraid_sas: Syncing request flags macro names with firmware
  megaraid_sas: Task management support
  megaraid_sas: Update device Queue depth based on interface type
  megaraid_sas: Fastpath region lock bypass
  megaraid_sas: Reply Descriptor Post Queue(RDPQ) support
  megaraid_sas: Code optimization build_and_issue_cmd return-type
  megaraid_sas: Dual Queue depth support
  megaraid_sas: IO throttling support
  megaraid_sas: Make adprecovery variable atomic
  megaraid_sas: MFI adapter's OCR changes
  megaraid_sas: Introduce module parameter for SCSI command-timeout
  megaraid_sas: SPERC OCR changes
  megaraid_sas: SPERC boot driver reorder

 drivers/scsi/megaraid/megaraid_sas.h        |  366 +++++++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 1373 +++++++++++++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1260 ++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  136 +++-
 5 files changed, 2404 insertions(+), 733 deletions(-)

