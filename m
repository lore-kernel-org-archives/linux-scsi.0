From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/14] qla2xxx: driver update.
Date: Mon, 29 Jan 2007 10:21:24 -0800
Message-ID: <20070129182124.GA26940@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:47526 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbXA2SV1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Jan 2007 13:21:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>

This patchset updates the qla2xxx driver to 8.01.07-k5.

 drivers/scsi/qla2xxx/qla_attr.c    |   68 +++++++-
 drivers/scsi/qla2xxx/qla_def.h     |   38 ++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |    6 +
 drivers/scsi/qla2xxx/qla_init.c    |  218 ++++++----------------
 drivers/scsi/qla2xxx/qla_isr.c     |  241 +++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |   18 +--
 drivers/scsi/qla2xxx/qla_os.c      |   24 +--
 drivers/scsi/qla2xxx/qla_sup.c     |  348 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 9 files changed, 745 insertions(+), 218 deletions(-)

here's the commits:

 -  Correct sector-erase issues while writing flash.
 -  Add MSI-X support.
 -  Handle IRQ-0 assignments by the system.
 -  Export OptionROM boot-codes version information.
 -  Perform implicit LOGO during fabric logout request.
 -  Set correct cabling state during initialization.
 -  Refactor set-HBA-model/description code.
 -  Check loop-state before reading host statistics.
 -  Fail initialization when inconsistent NVRAM detected.
 -  Enable queue-full throttling when UNDERRUN detected.
 -  Allow NVRAM updates to immediately go into affect.
 -  Fixup printk() with proper new-line character.
 -  Remove unnecessary spinlock primitive - mbx_reg_lock.
 -  Update version number to 8.01.07-k5.
