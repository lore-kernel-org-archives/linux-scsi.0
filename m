From: James Smart <james.smart@emulex.com>
Subject: [PATCH 0/19] lpfc 10.4.8000.0: Update lpfc version to driver
 version 10.4.8000.0
Date: Wed, 3 Sep 2014 12:54:48 -0400
Message-ID: <1409763288.12357.0.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:43837 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaICQz0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:55:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Update lpfc version to driver version 10.4.8000.0

This patch set updates the lpfc driver to revision 10.4.8000.0

The patches for 10.4.8000.0 contain:
- Incorporate patches posted to linux-scsi
  - Mark functions as static in lpfc/lpfc_sli.c
  - Mark functions as static in lpfc/lpfc_hbadisc.c
  - Mark functions as static in lpfc/lpfc_init.c
  - Mark functions as static in lpfc/lpfc_scsi.c
  - Mark function as static in lpfc/lpfc_bsg.c
  - Use time_after()
  - Use dma_zalloc_coherent
  - random32: do not feed jiffies as seed from lpfc driver
  - Use pci_enable_msix_range() instead of pci_enable_msix()
- Fix discovery timeout during nameserver login
- Fix quarantined XRI recovery qualifier state in link bounce 
- Fix IP Reset processing - wait for RDY before proceeding
- Fix race between LOGO/PLOGI handling causing NULL pointer
- Fix locking issues with abort data paths
- Fixed crash from page fault caused by use after rport delete
- Fixed High priority issues from lpfc given by fortify source code scan.
- Fixed Low priority issues from lpfc given by fortify source code scan.
- Fix for handling unmapped ndlp in target reset handler
- Update lpfc version to driver version 10.4.8000.0


The patches were cut against Christoph's scsi-queue.git,
branch "drivers-for-3.18".


-- james s


Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>

James Smart (19):

 drivers/scsi/lpfc/lpfc_attr.c      |   2 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |  20 ++-
 drivers/scsi/lpfc/lpfc_crtn.h      |   1 -
 drivers/scsi/lpfc/lpfc_ct.c        |  14 ++-
 drivers/scsi/lpfc/lpfc_debugfs.c   |   4 +-
 drivers/scsi/lpfc/lpfc_disc.h      |   6 +-
 drivers/scsi/lpfc/lpfc_els.c       |  33 +++--
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  53 +++++---
 drivers/scsi/lpfc/lpfc_init.c      | 225 ++++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_mbox.c      |   6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |   2 +
 drivers/scsi/lpfc/lpfc_scsi.c      |  34 +++--
 drivers/scsi/lpfc/lpfc_sli.c       | 247 ++++++++++++++++++-------------------
 drivers/scsi/lpfc/lpfc_sli.h       |   1 +
 drivers/scsi/lpfc/lpfc_sli4.h      |  20 +--
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 16 files changed, 351 insertions(+), 319 deletions(-)

-- 
1.7.11.7




