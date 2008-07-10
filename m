From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/18] qla2xxx: updates for 2.6.27 [8.02.01-k5].
Date: Thu, 10 Jul 2008 16:54:58 -0700
Message-ID: <20080710235458.GQ29099@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:45132 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbYGJXzD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 19:55:03 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Here's the first round of updates/fixes for 2.6.27.

 drivers/scsi/qla2xxx/qla_attr.c    |   69 +++++++++++++------
 drivers/scsi/qla2xxx/qla_dbg.c     |    2 +-
 drivers/scsi/qla2xxx/qla_def.h     |   12 ++-
 drivers/scsi/qla2xxx/qla_gbl.h     |    5 +-
 drivers/scsi/qla2xxx/qla_gs.c      |    6 ++
 drivers/scsi/qla2xxx/qla_init.c    |  126 ++++++++++++++++++++----------------
 drivers/scsi/qla2xxx/qla_iocb.c    |   23 ++++---
 drivers/scsi/qla2xxx/qla_isr.c     |    4 -
 drivers/scsi/qla2xxx/qla_mbx.c     |   12 ++-
 drivers/scsi/qla2xxx/qla_mid.c     |   15 ++---
 drivers/scsi/qla2xxx/qla_os.c      |   86 +++++++++++++++---------
 drivers/scsi/qla2xxx/qla_sup.c     |   48 +++++++++++++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 13 files changed, 261 insertions(+), 149 deletions(-)

here's the commits:

- Correct locking during NVRAM manipulation.
- Add dev_loss_tmo_callbk/terminate_rport_io callback support.
- Set an rport's dev_loss_tmo value in a consistent manner.
- Track total number of ISP aborts.
- Add LIP count to FC-transport statistics.
- Cleanup NPIV related functions
- Allow the user the option of disabling iIDMA.
- Retrieve board serial-number and description from VPD.
- Swap enablement order of EFT and FCE.
- Always aquire the parent's hardware_lock.
- Correct fcport state-management during loss.
- Correct vport management of MBA_PORT_UPDATE.
- Correct rport/fcport visibility-state handling during loop-resync.
- Skip FDMI registration on ISP21xx/22xx parts.
- Correct overflow during dump-processing on large-memory ISP23xx parts.
- Verify the RISC is not in ROM code if firmware-load is disabled.
- Don't hardcode fw_transfer_size for ISP2[45]xx parts.
- Update version number to 8.02.01-k5.

Regards,
Andrew Vasquez
QLogic Corporation
