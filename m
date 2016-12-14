From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V5 00/11] megaraid_sas: Updates for scsi-next
Date: Wed, 14 Dec 2016 17:12:57 -0500
Message-ID: <1481753588-101811-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:35384 "EHLO
        mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933121AbcLNWNU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2016 17:13:20 -0500
Received: by mail-qk0-f169.google.com with SMTP id n204so37193666qke.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2016 14:13:20 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, christopher.owens@broadcom.com, kiran-kumar.kasturi@broadcom.com, thenzl@redhat.com, sasikumar.pc@broadcom.com


Sasikumar Chandrasekaran (11):
  megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: 128 MSIX Support
  megaraid_sas: EEDP Escape Mode Support for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: SAS3.5 Generic Megaraid Controllers Stream Detection and
    IO Coalescing
  megaraid_sas: SAS3.5 Generic Megaraid Controllers Fast Path for RAID
    1/10 Writes
  megaraid_sas: Dynamic Raid Map Changes for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: Add the Support for SAS3.5 Generic Megaraid Controllers
    Capabilities
  megaraid_sas: Enable or Disable Fast path based on the PCI Threshold
    Bandwidth
  megaraid_sas: ldio_outstanding variable is not decremented in
    completion path
  megaraid_sas: Implement the PD Map support for SAS3.5 Generic Megaraid
    Controllers
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        | 139 ++++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 233 +++++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 293 +++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 742 +++++++++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 364 ++++++++++++--
 5 files changed, 1495 insertions(+), 276 deletions(-)

-- 
1.8.3.1

