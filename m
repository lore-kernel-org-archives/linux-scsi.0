From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/9] qla2xxx: updates for 2.6.23 [8.02.00-k2].
Date: Thu, 19 Jul 2007 15:04:56 -0700
Message-ID: <20070719220456.GK4015@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:26947 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763307AbXGSWGE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 18:06:04 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>

This patchset updates the qla2xxx driver to 8.02.00-k2.

 drivers/scsi/qla2xxx/qla_attr.c    |   33 +-
 drivers/scsi/qla2xxx/qla_dbg.c     |  919 ++++++++++++++++++++++++++++++++----
 drivers/scsi/qla2xxx/qla_dbg.h     |   38 ++
 drivers/scsi/qla2xxx/qla_def.h     |   22 +-
 drivers/scsi/qla2xxx/qla_fw.h      |   28 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    6 +
 drivers/scsi/qla2xxx/qla_gs.c      |   82 ++--
 drivers/scsi/qla2xxx/qla_init.c    |  136 +++---
 drivers/scsi/qla2xxx/qla_inline.h  |    4 +-
 drivers/scsi/qla2xxx/qla_iocb.c    |   10 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   55 ++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   58 ++--
 drivers/scsi/qla2xxx/qla_os.c      |  380 ++++++++++------
 drivers/scsi/qla2xxx/qla_sup.c     |   35 ++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 15 files changed, 1416 insertions(+), 392 deletions(-)

The bulk of the updates are infrastructure changes to support new ISP
parts (namely ISP25xx, our 8Gb product).  Actual ISP25xx additions are
relatively minor.

here's the commits:

- Generalize FW-Interface-2 support.
- Generalize iIDMA support.
- Correct setting of 'current' and 'supported' speeds during FDMI registration.
- Validate mid-layer 'underflow' during check-condition handling.
- Re-factor isp_operations to static structures.
- Use PCI-X/PCI-Express read control interfaces.
- Use pci_try_set_mwi().
- Add ISP25XX support.
- Update version number to 8.02.00-k2.


Regards,
Andrew Vasquez
QLogic Corporation
