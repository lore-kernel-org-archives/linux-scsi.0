From: james.smart@broadcom.com (James Smart)
Subject: [PATCH 00/21] lpfc: Update to revision 11.2.0.0
Date: Wed, 06 Jul 2016 12:35:53 -0700
Message-ID: <577d5d99.GQVS5IBL5oM3VXr7%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37266 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbcGFTf7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2016 15:35:59 -0400
Received: by mail-wm0-f53.google.com with SMTP id a66so5726489wme.0
        for <linux-scsi@vger.kernel.org>; Wed, 06 Jul 2016 12:35:58 -0700 (PDT)
Received: from flash ([192.19.245.250])
        by smtp.gmail.com with ESMTPSA id p191sm4156275wme.7.2016.07.06.12.35.55
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Jul 2016 12:35:56 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 11.2.0.00

The patches were cut against scsi-misc

James Smart (21):
  Fix Transgression Flag of Optical Element descriptor for RDP on Linux
  Correct RDP response sizing issue
  Add recovery from adapter parity errors on some SLI4 adapters
  Correct Buffer credit descriptor values in RDP response
  Reject RDP ELS if port has no login
  Add sysfs proc_name support
  Add MDS Diagnostics Support
  Fix SLI mode 2 config failure
  Correct FCOE discovery to avoid loss of storage devices after system
    reboot
  Re-organize source for easier device-id management
  Correct RDP response Revision location
  Add support for XLane LUN priority
  Correct Port reset resulting in FC port going offline
  Remove global lpfc_enable_npiv attribute in leiu of per-hba
    lpfc_enable_npiv
  Remove global lpfc_delay_discovery attribute in leiu of per-hba
    lpfc_delay_discovery
  Remove global lpfc_sli_mode attribute in leiu of per-hba lpfc_sli_mode
  Re-organize source for easier driver attribute management
  Correct issue with ioremap() call on 32bit kernel
  Disable FDMI probing if not connected to a fabric
  Copyright updates
  Update lpfc version to 11.2.0.0

 drivers/scsi/lpfc/lpfc.h         |  27 +++-
 drivers/scsi/lpfc/lpfc_attr.c    | 224 ++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_attr.h    | 116 ++++++++++++++++
 drivers/scsi/lpfc/lpfc_crtn.h    |   7 +-
 drivers/scsi/lpfc/lpfc_ct.c      |   4 +
 drivers/scsi/lpfc/lpfc_els.c     | 290 ++++++++++++++++++++++++++-------------
 drivers/scsi/lpfc/lpfc_hw.h      |  36 +++--
 drivers/scsi/lpfc/lpfc_hw4.h     |  41 +++++-
 drivers/scsi/lpfc/lpfc_ids.h     | 122 ++++++++++++++++
 drivers/scsi/lpfc/lpfc_init.c    | 277 ++++++++++++++++++-------------------
 drivers/scsi/lpfc/lpfc_scsi.c    |  14 +-
 drivers/scsi/lpfc/lpfc_scsi.h    |   3 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  99 ++++++++++---
 drivers/scsi/lpfc/lpfc_sli.h     |   3 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |   4 +-
 drivers/scsi/lpfc/lpfc_version.h |   2 +-
 16 files changed, 843 insertions(+), 426 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_attr.h
 create mode 100644 drivers/scsi/lpfc/lpfc_ids.h

-- 
2.5.0

