From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/5] qla2xxx: more updates/fixes for 2.6.27 [8.02.01-k6].
Date: Thu, 24 Jul 2008 08:31:08 -0700
Message-ID: <20080724153108.GI561@plap4-2.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22962 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYGXPbL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jul 2008 11:31:11 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Seokmann Ju <seokmann.ju@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>

Another round of updates/fixes for 2.6.27.

 drivers/scsi/qla2xxx/qla_attr.c    |   49 ++++++++++-------------------------
 drivers/scsi/qla2xxx/qla_init.c    |    7 +++--
 drivers/scsi/qla2xxx/qla_iocb.c    |    9 +++---
 drivers/scsi/qla2xxx/qla_mbx.c     |    7 ++---
 drivers/scsi/qla2xxx/qla_mid.c     |    1 +
 drivers/scsi/qla2xxx/qla_os.c      |    8 +++--
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 7 files changed, 32 insertions(+), 51 deletions(-)

here's the commits:

- Issue proper ISP callbacks during stop-firmware.
- use memory_read_from_buffer()
- drivers/scsi/qla2xxx/qla_os.c: suppress uninitialized-var warning
- Additional NPIV corrections.
- Update version number to 8.02.01-k6.

Regards,
Andrew Vasquez
QLogic Corporation
