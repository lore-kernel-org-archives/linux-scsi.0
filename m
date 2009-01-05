From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 0/8] qla2xxx: updates for 2.6.29 [8.03.00-k1].
Date: Mon,  5 Jan 2009 11:18:04 -0800
Message-ID: <1231183092-10471-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22498 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZAETSP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 14:18:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>

Here's another round of updates/fixes for 2.6.29.

--

Andrew Vasquez (8):
  qla2xxx: Remove support for reading/writing HW-event-log.
  qla2xxx: Don't fallback to interrupt-polling during re-initialization
    with MSI-X enabled.
  qla2xxx: Don't pollute kernel logs with ZIO/RIO status messages.
  qla2xxx: Collapse EFT/FCE copy procedures during a firmware dump.
  qla2xxx: Correct MQ-chain information retrieval during a firmware
    dump.
  qla2xxx: Use proper request/response queues with MQ instantiations.
  qla2xxx: Add ISP81XX support.
  qla2xxx: Update version number to 8.03.00-k1.

 drivers/scsi/qla2xxx/qla_attr.c    |   26 ++-
 drivers/scsi/qla2xxx/qla_dbg.c     |  462 +++++++++++++++++++++++++++++++-----
 drivers/scsi/qla2xxx/qla_dbg.h     |   40 +++
 drivers/scsi/qla2xxx/qla_def.h     |   33 ++-
 drivers/scsi/qla2xxx/qla_dfs.c     |    3 +-
 drivers/scsi/qla2xxx/qla_fw.h      |  294 +++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   10 +-
 drivers/scsi/qla2xxx/qla_gs.c      |    9 +-
 drivers/scsi/qla2xxx/qla_init.c    |  295 ++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |   12 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   82 +++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |   41 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |    4 +-
 drivers/scsi/qla2xxx/qla_os.c      |  139 ++++++++----
 drivers/scsi/qla2xxx/qla_sup.c     |  263 +++++++--------------
 drivers/scsi/qla2xxx/qla_version.h |    6 +-
 16 files changed, 1345 insertions(+), 374 deletions(-)

