From: james.smart@avagotech.com (James Smart)
Subject: [PATCH v2 00/15] lpfc: Update to revision 10.6.0.1
Date: Thu, 21 May 2015 13:55:15 -0400
Message-ID: <555e1c03.Lo0g2qHl+o8QC42E%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:33173 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbbEURzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 May 2015 13:55:20 -0400
Received: by qgfa63 with SMTP id a63so25673029qgf.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 May 2015 10:55:19 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by mx.google.com with ESMTPSA id 69sm4970290qkv.22.2015.05.21.10.55.18
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Thu, 21 May 2015 10:55:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 10.6.0.1

This is version 2.

v2 changes:
  Patch 3: Revised for review comments from Sebastian Herbszt
           Replaced double spacing with single spacing 
  Patch 6: Revised for review comments from Sebastian Herbszt
           Replaced double spacing with single spacing 
	   Revised LS_RJT codes for lpfc_els_rcv_rdp()

The patches were cut against scsi-misc

-- james


James Smart (15):
  The lpfc driver does not issue RFF_ID and RFT_ID in the correct
    sequence
  Correct loss of target discovery after cable swap.
  Add support for ELS LCB.
  Correct reference counting of rport
  Fix ABORTs WQ selection in terminate_rport_io
  Add support for RDP ELS command.
  Correct reporting of vport state on fdisc command failure.
  Fix discovery issue when changing from Pt2Pt to Fabric.
  Fix to remove IRQF_SHARED flag for MSI/MSI-X vectors.
  Fix crash in vport_delete.
  Correct loss of RSCNs during array takeaway/giveback testing.
  Fix rport leak.
  Fix incorrect log message reported for empty FCF record.
  Change buffer pool empty message to miscellaneous category
  Update driver version for upstream patch set 10.6.0.1.

 drivers/scsi/lpfc/lpfc.h           |   2 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +
 drivers/scsi/lpfc/lpfc_disc.h      |   4 +-
 drivers/scsi/lpfc/lpfc_els.c       | 686 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 168 ++++-----
 drivers/scsi/lpfc/lpfc_hw.h        | 201 +++++++++++
 drivers/scsi/lpfc/lpfc_hw4.h       | 228 +++++++++++-
 drivers/scsi/lpfc/lpfc_init.c      |  22 +-
 drivers/scsi/lpfc/lpfc_mbox.c      | 152 ++++++++
 drivers/scsi/lpfc/lpfc_nportdisc.c |   8 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  32 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |  21 ++
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   9 +-
 15 files changed, 1415 insertions(+), 124 deletions(-)

-- 
1.7.11.7

