From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/21] qla2xxx: Driver update [8.02.01-k1].
Date: Thu, 3 Apr 2008 13:11:52 -0700
Message-ID: <20080403201152.GB8033@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5979 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014AbYDCULz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Apr 2008 16:11:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.02.01-k1

 drivers/scsi/qla2xxx/Kconfig        |    3 +-
 drivers/scsi/qla2xxx/qla_attr.c     |   36 +++-
 drivers/scsi/qla2xxx/qla_dbg.c      |  124 +----------
 drivers/scsi/qla2xxx/qla_dbg.h      |   23 +--
 drivers/scsi/qla2xxx/qla_def.h      |   78 ++++++-
 drivers/scsi/qla2xxx/qla_dfs.c      |    2 +-
 drivers/scsi/qla2xxx/qla_fw.h       |  173 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h      |   33 ++-
 drivers/scsi/qla2xxx/qla_gs.c       |   16 +-
 drivers/scsi/qla2xxx/qla_init.c     |  192 +++++++++++-----
 drivers/scsi/qla2xxx/qla_inline.h   |   87 +-------
 drivers/scsi/qla2xxx/qla_iocb.c     |    5 +-
 drivers/scsi/qla2xxx/qla_isr.c      |  223 ++++++++----------
 drivers/scsi/qla2xxx/qla_mbx.c      |  318 +++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_mid.c      |   30 +--
 drivers/scsi/qla2xxx/qla_os.c       |  443 +++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_settings.h |   16 +--
 drivers/scsi/qla2xxx/qla_sup.c      |  315 ++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_version.h  |    6 +-
 19 files changed, 1266 insertions(+), 857 deletions(-)

here's the commits:

- Update firmware filenames for new ISP parts.
- Update copyright banner.
- Add support for host supported speeds FC transport attribute.
- Remove unused and obsolete #define's.
- Use an rport's scsi_target_id member consistently throughout driver.
- Simplify interrupt handler locking.
- Add FC-transport Asynchronous Event Notification support.
- Add hardware trace-logging support.
- Cruft cleanup of functions and structures.
- Use PCI-SIG nomenclature for PCIe bandwidth units.
- Add Flash Descriptor Table layout support.
- Check alternate 'reason' code during GPSC status handling.
- Add midlayer target/device reset support.
- Assign mailbox command timeout values in a consistent manner.
- Add ISP84XX support.
- Remove unused member (dma_handle) from srb_t structure.
- Consistently access the physical HA port.
- Check DFLG_NO_CABLE only on physical port.
- Use proper HA during asynchrounous event handling.
- Correct vport configuration-change handling.
- Update version number to 8.02.01-k1.

Regards,
Andrew Vasquez
QLogic Corporation
