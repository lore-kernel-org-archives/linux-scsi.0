From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH 0/7] megaraid_sas: Updates for scsi-next
Date: Mon, 17 Oct 2016 03:24:03 -0700
Message-ID: <1476699850-25083-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:33841 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933510AbcJQKYW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 06:24:22 -0400
Received: by mail-pf0-f176.google.com with SMTP id r16so54441121pfg.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2016 03:24:21 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

Sumit Saxena (7):
  megaraid_sas: For SRIOV enabled firmware, ensure VF driver waits for
    30secs before reset
  megaraid_sas: Send correct PhysArm to FW for R1 VD downgrade
  megaraid_sas: Do not fire DCMDs during PCI shutdown/detach
  megaraid_sas: Send SYNCHRONIZE_CACHE command to firmware
  megaraid_sas: driver version upgrade
  MAINTAINERS: Update megaraid maintainers list
  megaraid_sas: Do not set MPI2_TYPE_CUDA for JBOD FP path for FW which
    does not support JBOD sequence map

 MAINTAINERS                                 | 10 ++---
 drivers/scsi/megaraid/megaraid_sas.h        |  7 +++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 60 +++++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  6 ++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 21 ++++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  2 +
 6 files changed, 82 insertions(+), 24 deletions(-)

-- 
1.8.3.1

