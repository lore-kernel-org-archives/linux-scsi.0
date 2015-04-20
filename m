From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/14] lpfc: Update lpfc driver to revision 10.6.0.1
Date: Mon, 20 Apr 2015 09:56:23 -0400
Message-ID: <55350587.g0H8dpKN8J7/7HWX%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:29298 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbbDTN5D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2015 09:57:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 10.6.0.1

The patches were cut against scsi-misc


-- james s


James Smart (14):
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
  Fix incorrect log message reported for empty FCF record.
  Change buffer pool empty message to miscellaneous category
  Update driver version for upstream patch set 10.6.0.1.

 drivers/scsi/lpfc/lpfc.h           |   2 +
 drivers/scsi/lpfc/lpfc_crtn.h      |   2 +
 drivers/scsi/lpfc/lpfc_disc.h      |   4 +-
 drivers/scsi/lpfc/lpfc_els.c       | 681 ++++++++++++++++++++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 168 ++++-----
 drivers/scsi/lpfc/lpfc_hw.h        | 201 +++++++++++
 drivers/scsi/lpfc/lpfc_hw4.h       | 228 ++++++++++++-
 drivers/scsi/lpfc/lpfc_init.c      |  22 +-
 drivers/scsi/lpfc/lpfc_mbox.c      | 152 +++++++++
 drivers/scsi/lpfc/lpfc_nportdisc.c |   8 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  32 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |  21 ++
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   9 +-
 15 files changed, 1410 insertions(+), 124 deletions(-)

-- 
1.7.11.7

