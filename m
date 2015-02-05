From: James Smart <james.smart@emulex.com>
Subject: [PATCH 00/21] lpfc: Update lpfc version to driver version 10.5.0.0
Date: Thu, 5 Feb 2015 14:22:52 -0500
Message-ID: <1423164172.7917.24.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:20659 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752500AbbBETXd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2015 14:23:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set updates the lpfc driver to revision 10.5.0.0

The patches were cut against Christoph's scsi-queue.git,
branch "drivers-for-3.20".


-- james s


James Smart (21):
  Fix the iteration count to match the 30 sec comment
  Add Lancer Temperature Event support to the lpfc driver
  EnableBootCode from hbacmd fails on Lancer
  Fix to handle PLOGI when already logged in
  Linux lpfc driver doesn't re-establish the link after a cable pull on
    LPe12002
  Fix host reset escalation killing all IOs.
  Fix setting of EQ delay Multiplier
  lpfc does not support option_rom_version sysfs attribute on newer
    adapters
  Parse the new 20G, 25G and 40G link speeds in the lpfc driver
  Fix provide host name and OS name in RSNN-NN FC-GS command
  Fix FDMI Fabric support in driver for Brocade
  Fix null ndlp derefernce in target_reset_handler
  Initiator sends wrong BBCredit value for either FLOGI or FLOGI_ACC
  Fix premature release of rpi bit in bitmask
  Implement support for wire-only DIF devices
  Fix internal loopback failure.
  OCM causes OS crash when running diagnostics on Lancer
  Fix crash in device reset handler.
  Fix for lun discovery issue with saturn adapter.
  Update copyright to 2015
  Update version  to 10.5.0.0 for upstream patch set

 drivers/scsi/lpfc/lpfc.h           |  46 ++-
 drivers/scsi/lpfc/lpfc_attr.c      |  90 ++++-
 drivers/scsi/lpfc/lpfc_bsg.c       |   4 +-
 drivers/scsi/lpfc/lpfc_bsg.h       |   3 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   7 +-
 drivers/scsi/lpfc/lpfc_ct.c        | 740 ++++++++++++++++++++++++++++---------
 drivers/scsi/lpfc/lpfc_debugfs.c   |   2 +-
 drivers/scsi/lpfc/lpfc_els.c       |  19 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |  77 +++-
 drivers/scsi/lpfc/lpfc_hw.h        | 208 +++++------
 drivers/scsi/lpfc/lpfc_hw4.h       |   8 +-
 drivers/scsi/lpfc/lpfc_init.c      | 289 +++++++++++----
 drivers/scsi/lpfc/lpfc_mbox.c      |   6 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  29 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 493 +++++++++++++++++++++---
 drivers/scsi/lpfc/lpfc_scsi.h      |   9 +-
 drivers/scsi/lpfc/lpfc_sli.c       | 108 ++++--
 drivers/scsi/lpfc/lpfc_sli.h       |   3 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |   4 +-
 drivers/scsi/lpfc/lpfc_version.h   |   6 +-
 20 files changed, 1633 insertions(+), 518 deletions(-)

-- 
1.7.11.7

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>



