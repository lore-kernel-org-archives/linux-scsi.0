From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/6] qla2xxx: fixes for 2.6.23 [8.02.00-k3].
Date: Sun, 12 Aug 2007 18:22:18 -0700
Message-ID: <20070813012218.GD1067@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:31517 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764781AbXHMBWU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Aug 2007 21:22:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset contains fixes for 2.6.23.

 drivers/scsi/qla2xxx/qla_dbg.c     |   21 ++++++--------
 drivers/scsi/qla2xxx/qla_def.h     |    1 -
 drivers/scsi/qla2xxx/qla_gs.c      |   24 ++++++++++++----
 drivers/scsi/qla2xxx/qla_init.c    |   51 ++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_isr.c     |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |    2 +-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 7 files changed, 45 insertions(+), 57 deletions(-)

here's the commits:

- Allocate enough space for the full PCI descriptor.
- Don't modify parity bits during ISP25XX restart.
- Correct management-server login-state synchronization issue.
- Correct 8GB iIDMA support.
- Correct mailbox register dump for FWI2 capable ISPs.
- Update version number to 8.02.00-k3.

Regards,
Andrew Vasquez
QLogic Corporation
