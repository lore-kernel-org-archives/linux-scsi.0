From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/8] qla2xxx: Driver updates for 2.6.24 [8.02.00-k5].
Date: Fri, 19 Oct 2007 15:58:24 -0700
Message-ID: <20071019225824.GG24197@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:28975 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344AbXJSW6g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Oct 2007 18:58:36 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.02.00-k5

 drivers/scsi/qla2xxx/qla_attr.c    |    9 ++----
 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_devtbl.h  |    7 ++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |    8 +++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |    2 +-
 drivers/scsi/qla2xxx/qla_os.c      |   50 +++++++++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_sup.c     |   25 ++++++++++++++++--
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 9 files changed, 72 insertions(+), 34 deletions(-)

here's the commits:

- Resync with latest HBA SSID specification -- 2.2u.
- Defer explicit interrupt-polling processing to init-time scenarios.
- Handle unaligned sector writes during NVRAM/VPD updates.
- Fix issue where final flash-segment updates were falling into the slow-path write handler.
- Make driver (mostly) legacy I/O port free.
- Correct residual-count handling discrepancies during UNDERRUN handling.
- Correct display of ISP serial-number.
- Update version number to 8.02.00-k5.

Regards,
Andrew Vasquez
QLogic Corporation
