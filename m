From: Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>
Subject: [PATCH V4 00/11] megaraid_sas: Updates for scsi-next
Date: Tue,  6 Dec 2016 18:00:09 -0500
Message-ID: <1481065220-18431-1-git-send-email-sasikumar.pc@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f170.google.com ([209.85.220.170]:34306 "EHLO
        mail-qk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750953AbcLFXA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 18:00:29 -0500
Received: by mail-qk0-f170.google.com with SMTP id q130so208837354qke.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2016 15:00:29 -0800 (PST)
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

 drivers/scsi/megaraid/megaraid_sas.h        | 139 +++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 240 +++++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     | 343 +++++++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 756 +++++++++++++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h | 364 ++++++++++++--
 5 files changed, 1564 insertions(+), 278 deletions(-)

-- 
1.8.3.1

