From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/14] qla2xxx: updates for 2.6.24 [8.02.00-k7].
Date: Thu, 17 Jan 2008 08:59:40 -0800
Message-ID: <20080117165940.GA19033@plap3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:20181 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbYAQQ7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Jan 2008 11:59:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@steeleye.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

This patchset updates the qla2xxx driver to 8.02.00-k7.

 drivers/scsi/qla2xxx/Makefile      |    2 +-
 drivers/scsi/qla2xxx/qla_attr.c    |   52 +++--
 drivers/scsi/qla2xxx/qla_dbg.c     |   37 ++--
 drivers/scsi/qla2xxx/qla_dbg.h     |   19 ++
 drivers/scsi/qla2xxx/qla_def.h     |   42 +++--
 drivers/scsi/qla2xxx/qla_dfs.c     |  175 +++++++++++++++
 drivers/scsi/qla2xxx/qla_fw.h      |   14 ++
 drivers/scsi/qla2xxx/qla_gbl.h     |   51 ++---
 drivers/scsi/qla2xxx/qla_init.c    |   80 ++++++--
 drivers/scsi/qla2xxx/qla_isr.c     |  105 ++++-----
 drivers/scsi/qla2xxx/qla_mbx.c     |  426 ++++++++++++------------------------
 drivers/scsi/qla2xxx/qla_mid.c     |   13 +-
 drivers/scsi/qla2xxx/qla_os.c      |   80 +++-----
 drivers/scsi/qla2xxx/qla_sup.c     |   18 +-
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 15 files changed, 616 insertions(+), 500 deletions(-)

here's the commits:

- Consolidate duplicate sense-data handling codes.
- Retrieve additional HBA port statistics from recent ISPs.
- Fix for 32-bit platforms with 64-bit resources.
- Wait for FLASH write-protection to complete after a write.
- Restrict MSI/MSI-X enablement on select ISP2432-type HBAs.
- Don't schedule the DPC routine to perform an issue-lip request.
- Use completion routines.
- Add a filter to compare port_name against the physical on vport creation.
- Code cleanups.
- Trace-Control naming cleanups.
- Add Fibre Channel Event (FCE) tracing support.
- Correct late-memset() of EFT buffer.
- Issue correct MBC_INITIALIZE_FIRMWARE command.
- Update version number to 8.02.00-k7.

Regards,
Andrew Vasquez
QLogic Corporation
