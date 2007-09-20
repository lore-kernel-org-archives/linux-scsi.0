From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/19] qla2xxx: Driver update [8.02.00-k4].
Date: Thu, 20 Sep 2007 14:04:22 -0700
Message-ID: <20070920210422.GE8456@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:10494 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbXITVE3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Sep 2007 17:04:29 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>

This patchset updates the qla2xxx driver to 8.02.00-k4

 drivers/scsi/qla2xxx/qla_attr.c    |  200 +++--
 drivers/scsi/qla2xxx/qla_dbg.c     | 1846 +++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_dbg.h     |    2 +
 drivers/scsi/qla2xxx/qla_def.h     |   15 +-
 drivers/scsi/qla2xxx/qla_fw.h      |    6 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    9 +-
 drivers/scsi/qla2xxx/qla_gs.c      |    6 +-
 drivers/scsi/qla2xxx/qla_init.c    |   26 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   88 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   62 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |   40 +-
 drivers/scsi/qla2xxx/qla_os.c      |  140 +++-
 drivers/scsi/qla2xxx/qla_sup.c     |  221 ++++--
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 15 files changed, 1189 insertions(+), 1478 deletions(-)

here's the commits:

- Collapse and simplify ISP2XXX firmware dump routines.
- Add flash burst-read/write support.
- Limit iIDMA speed adjustments.
- Allow region-based flash-part accesses.
- Add PCI error recovery support.
- Query additional RISC information during a pause.
- Correct staging of RISC while attempting to pause.
- Query additional RISC registers during ISP25XX firmware dump.
- Correct infinite-login-retry issue.
- Set correct attribute count during FDMI RPA.
- Use the correct pointer-address during NVRAM writes.
- Retrieve max-NPIV support capabilities from FW.
- Remove unused member (list) from srb_t structure.
- Use shost_priv().
- Cleanup several 'sparse' warnings.
- Sparse cleanups in qla_mid.c
- Clear options-flags while staging firmware-execution.
- Rework MSI-X handlers.
- Update version number to 8.02.00-k4.

Regards,
Andrew Vasquez
QLogic Corporation
