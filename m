From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 00/19] megaraid_sas: Updates for scsi-next
Date: Thu, 19 Oct 2017 02:48:47 -0700
Message-ID: <1508406546-25944-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:43362 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdJSJtu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Oct 2017 05:49:50 -0400
Received: by mail-pg0-f67.google.com with SMTP id s75so6763799pgs.0
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 02:49:50 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Shivasharan S (19):
  megaraid_sas: use adapter_type for all gen controllers
  megaraid_sas: Add support for Crusader controllers
  megaraid_sas: replace instance->ctrl_context checks with
    instance->adapter_type
  megaraid_sas: Remove redundant checks for ctrl_context
  megaraid_sas: replace is_ventura with adapter_type checks
  megaraid_sas: reduce size of fusion_context and use kmalloc for
    allocation
  megaraid_sas: Create separate functions to allocate ctrl memory
  megaraid_sas: Create separate functions for allocating and freeing
    controller DMA buffers
  megaraid_sas: Pre-allocate frequently used DMA buffers
  megaraid_sas: remove instance->ctrl_info
  megaraid_sas: Move initialization of instance parameters inside newly
    created function megasas_init_ctrl_params
  megaraid_sas: Move controller memory allocations and DMA mask settings
    from probe to megasas_init_fw
  megaraid_sas: Update current host time to FW during IOC Init
  megaraid_sas: Resize MFA frame used for IOC INIT to 4k
  megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP
    commands
  megaraid_sas: Retry with reduced queue depth when alloc fails for
    higher QD
  megaraid_sas: Do not limit queue_depth to 1k in non-RDPQ mode
  megaraid_sas: Add support for 64bit consistent DMA
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |   64 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 1023 +++++++++++++++++----------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |   20 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  676 +++++++++++++-----
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   29 +-
 5 files changed, 1207 insertions(+), 605 deletions(-)

-- 
2.14.1.dirty
