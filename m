From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 00/20] lpfc: Update lpfc driver to revision 10.5.0.0
Date: Tue, 7 Apr 2015 15:07:07 -0400
Message-ID: <55242adb.qr1UDF9+UzxYcWLh%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:27592 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753401AbbDGTIL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:11 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


This patch set updates the lpfc driver to revision 10.5.0.0

This is version 3.

v3 changes:
  revised comment on patch10 to remove Emulex BZ # that was irrelevant
  dropped prior patch15: "Implement support for wire-only DIF devices"

v2 changes:
  Patches recut with the signed-by's reordered
  Additional comments added on some patches.
  Prior Patch 9 and 10 have minor 1 line changes per review comments


The patches were cut against Christoph's scsi-queue.git,
branch "drivers-for-3.20".


-- james s



*** BLURB HERE ***

James Smart (20):
  Fix the iteration count to match the 30 sec comment in the routine
    lpfc_pci_function_reset
  Add Lancer Temperature Event support to the lpfc driver
  Add new mbx cmd recognition
  Fix to handle PLOGI when already logged in
  Linux lpfc driver doesn't re-establish the link after a cable pull on
    LPe12002
  Fix host reset escalation killing all IOs.
  Fix setting of EQ (interrupt) delay Multiplier
  Add support for reporting option_rom_version on newer adapters
  Parse the new 20G, 25G and 40G link speeds in the lpfc driver
  Fix provide host name and OS name in RSNN-NN FC-GS command
  Fix FDMI Fabric support in driver for Brocade
  Fix null ndlp dereference in target_reset_handler
  Initiator sends wrong BBCredit value for either FLOGI or FLOGI_ACC
  Fix premature release of rpi bit in bitmask
  Fix internal loopback failure.
  Fix OS crash when running loopback test in applications
  Fix crash in device reset handler.
  Fix for lun discovery issue with saturn adapter.
  Update copyright to 2015
  Update version  to 10.5.0.0 for upstream patch set

 drivers/scsi/lpfc/lpfc.h           |   5 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  25 +-
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +-
 drivers/scsi/lpfc/lpfc_bsg.h       |   3 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   4 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 738 ++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_debugfs.c   |   2 +-
 drivers/scsi/lpfc/lpfc_els.c       |  19 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  74 +++-
 drivers/scsi/lpfc/lpfc_hw.h        | 208 +++++------
 drivers/scsi/lpfc/lpfc_hw4.h       |   8 +-
 drivers/scsi/lpfc/lpfc_init.c      | 264 +++++++++----
 drivers/scsi/lpfc/lpfc_mbox.c      |   2 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  29 +-
 drivers/scsi/lpfc/lpfc_scsi.c      |  83 +++--
 drivers/scsi/lpfc/lpfc_scsi.h      |   2 +-
 drivers/scsi/lpfc/lpfc_sli.c       |  72 +++-
 drivers/scsi/lpfc/lpfc_sli.h       |   3 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 20 files changed, 1099 insertions(+), 456 deletions(-)

-- 
1.7.11.7

