From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: [PATCH 00/26] qla2xxx: updates for 2.6.30 [8.03.01-k1].
Date: Tue, 24 Mar 2009 09:07:54 -0700
Message-ID: <1237910900-30817-1-git-send-email-andrew.vasquez@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:29874 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761333AbZCXQIW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2009 12:08:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Seokmann Ju <seokmann.ju@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

Another round of updates/fixes for 2.6.30.

 drivers/scsi/qla2xxx/qla_attr.c    |  295 ++++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_def.h     |  136 +++++------------
 drivers/scsi/qla2xxx/qla_dfs.c     |    4 +-
 drivers/scsi/qla2xxx/qla_fw.h      |   42 +++++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   25 +++-
 drivers/scsi/qla2xxx/qla_init.c    |  136 ++++++-----------
 drivers/scsi/qla2xxx/qla_iocb.c    |   37 +----
 drivers/scsi/qla2xxx/qla_isr.c     |   32 +----
 drivers/scsi/qla2xxx/qla_mbx.c     |  238 +++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mid.c     |   12 ++-
 drivers/scsi/qla2xxx/qla_os.c      |  258 ++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_sup.c     |  103 ++++++++++---
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 13 files changed, 854 insertions(+), 468 deletions(-)

Here's the commits:

Andrew Vasquez (12):
  qla2xxx: Refactor request/response-queue register handling.
  qla2xxx: Always (re)read firmware version/capabilities information.
  qla2xxx: Pass in optional extended-initialization control block.
  qla2xxx: Preserve an fcport's loop-id after terminate_rport_io().
  qla2xxx: Update MPI/PHY version retrieval codes.
  qla2xxx: Correct abort-semantics in qla2x00_abort_all_cmds().
  qla2xxx: Ensure the timer and DPC routines complete prior to midlayer
    tear-down.
  qla2xxx: Always use an FLT's NVRAM/VPD region information.
  qla2xxx: Reduce request queue-size overhead with recent ISPs.
  qla2xxx: Explicitly set the execution-throttle with recent ISPs.
  qla2xxx: Don't cache VPD data for newer ISPs.
  qla2xxx: Update version number to 8.03.01-k1.

Giridhar Malavali (4):
  qla2xxx: Consolidate queuecommand implementations.
  qla2xxx: Initialize FCE debugfs codes with the proper vha structure.
  qla2xxx: Correct over-allocation of firmware-dump buffer.
  qla2xxx: Drop use of IRQF_DISABLE.

Harish Zunjarrao (2):
  qla2xxx: Use byte-address while reading FC boot code versions from
    flash.
  qla2xxx: Get FLT address in dword format.

Joe Carnuccio (2):
  qla2xxx: Add Flash-Access-Control support for recent ISPs.
  qla2xxx: Add EDC-update support.

Lalit Chandivade (4):
  qla2xxx: Correct ISP abort semantics for NVRAM, VPD, and flash
    update.
  qla2xxx: Add reset capabilities for application support.
  qla2xxx: Remove implicit ISP-abort after a flash update.
  qla2xxx: Export flash-block-size for application support.

Seokmann Ju (1):
  qla2xxx: Correct several PCI-EEH issues.

Shyam Sundar (1):
  qla2xxx: Cleanup unused flags and #defines.
