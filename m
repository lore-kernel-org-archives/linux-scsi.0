From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 00/15] megaraid_sas: Updates for scsi-next
Date: Fri, 30 Jun 2017 01:29:54 -0700
Message-ID: <1498811409-11157-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:35914 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751579AbdF3Iap (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2017 04:30:45 -0400
Received: by mail-pg0-f46.google.com with SMTP id u62so60415234pgb.3
        for <linux-scsi@vger.kernel.org>; Fri, 30 Jun 2017 01:30:45 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Shivasharan S (15):
  megaraid_sas: mismatch of allocated MFI frame size and length exposed
    in MFI MPT pass through command
  megaraid_sas: set minimum value of resetwaittime to be 1 secs
  megaraid_sas: Use synchronize_irq in target reset case
  megaraid_sas: Call megasas_complete_cmd_dpc_fusion every 1 second
    while there are pending commands
  megaraid_sas: Do not re-fire shutdown DCMD after OCR
  megaraid_sas: Fix endianness issues in DCMD handling
  megaraid_sas: Check valid aen class range to avoid kernel panic
  megaraid_sas: Use SMID for Task abort case only
  megaraid_sas: use vmalloc for crash dump buffers and driver's local
    RAID map
  megaraid_sas: Return pended IOCTLs with cmd_status
    MFI_STAT_WRONG_STATE in case adapter is dead
  megaraid_sas: Set device queue_depth same as HBA can_queue value in
    scsi-mq mode
  megaraid_sas: replace internal FALSE/TRUE definitions with false/true
  megaraid_sas: modified few prints in OCR and IOC INIT path
  megaraid_sas: call megasas_dump_frame with correct IO frame size
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  44 ++++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  40 +++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 161 +++++++++++++++++-----------
 4 files changed, 149 insertions(+), 101 deletions(-)

-- 
2.8.3
