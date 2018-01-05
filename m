From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 00/14] megaraid_sas: driver updates
Date: Fri,  5 Jan 2018 05:27:35 -0800
Message-ID: <1515158869-26693-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:37087 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751594AbeAEN3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 08:29:07 -0500
Received: by mail-pg0-f48.google.com with SMTP id o13so1994017pgp.4
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jan 2018 05:29:07 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Shivasharan S (14):
  megaraid_sas: zero out IOC INIT and stream detection memory
  megaraid_sas: memset IOC INIT frame using correct size
  megaraid_sas: Return the DCMD status from megasas_get_seq_num
  megaraid_sas: Reset ldio_outstanding in megasas_resume
  megaraid_sas: Error handling for invalid ldcount provided by firmware
    in RAID map
  megaraid_sas: unload flag should be set after scsi_remove_host is
    called
  megaraid_sas: Avoid firing DCMDs while OCR is in progress
  megaraid_sas: Use megasas_wait_for_adapter_operational to detect
    controller state in IOCTL path
  megaraid_sas: Update LD map after populating drv_map driver map copy
  megaraid_sas: Selectively apply stream detection based on IO type
  megaraid_sas: Expose fw_cmds_outstanding through sysfs
  megaraid_sas: re-work DCMD refire code
  megaraid_sas: NVME passthru command support
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |  37 ++++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 171 ++++++++++++++--------------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  28 +++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  92 ++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   6 +
 5 files changed, 198 insertions(+), 136 deletions(-)

-- 
2.14.1
