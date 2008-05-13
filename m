From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/10] qla2xxx: updates for 2.6.26 [8.02.01-k3].
Date: Mon, 12 May 2008 22:19:48 -0700
Message-ID: <20080513051948.GN22377@plap4.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:52191 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbYEMFTt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 01:19:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset contains another round of fixes/updates for 2.6.26.

 drivers/scsi/qla2xxx/qla_attr.c    |   13 ++++++++++---
 drivers/scsi/qla2xxx/qla_def.h     |    2 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    3 +++
 drivers/scsi/qla2xxx/qla_inline.h  |    4 ++++
 drivers/scsi/qla2xxx/qla_isr.c     |   27 ++++-----------------------
 drivers/scsi/qla2xxx/qla_mbx.c     |   12 ++++--------
 drivers/scsi/qla2xxx/qla_mid.c     |   18 +++++++++---------
 drivers/scsi/qla2xxx/qla_os.c      |   16 +++++++++-------
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 9 files changed, 45 insertions(+), 52 deletions(-)

here's the commits:

- Return correct port_type to FC-transport for Vports.
- Display driver version at module init-time.
- Correct locking within MSI-X interrupt handlers.
- firmware semaphore to mutex
- Convert vport_sem to a mutex
- Don't depend on mailbox return values while enabling FCE tracing.
- Extend the 'fw_dump' SYSFS node the ability to initiate a firmware dump.
- Disable local-interrupts while polling for RISC status.
- Revert "qla2xxx: Validate mid-layer 'underflow' during check-condition handling."
- Update version number to 8.02.01-k3.

Regards,
Andrew Vasquez
QLogic Corporation
