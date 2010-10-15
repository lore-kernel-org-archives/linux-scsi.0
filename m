From: madhu.iyengar@qlogic.com
Subject: [PATCH 00/12] qla2xxx: Updates for scsi-misc-2.6.
Date: Fri, 15 Oct 2010 11:27:37 -0700
Message-ID: <1287167269-8034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36970 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1756316Ab0JOSga (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2010 14:36:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please apply these patches. Thanks.

Andrew Vasquez (2):
  qla2xxx: Initialize the vport_slock spinlock.
  qla2xxx: Correct PRLI failure response code handling.

Chad Dupuis (4):
  qla2xxx: Remove port down retry count.
  qla2xxx: Add module parameter to enable/disable GFF_ID device type
    check.
  qla2xxx: Change del_timer_sync() to del_timer() in
    qla2x00_ctx_sp_free().
  qla2xxx: Group CS_RESET return status with other link level event
    statuses.

Dan Carpenter (1):
  qla2xxx: locking problem in qla2x00_init_rings()

Giridhar Malavali (1):
  qla2xxx: Avoid depending on SCSI host_lock in queuecommand function.

Harish Zunjarrao (1):
  qla2xxx: Add flash read/update support using BSG interface

Madhuranath Iyengar (2):
  qla2xxx: Remove scsi_cmnd->serial_number from debug traces
  qla2xxx: Addition of shutdown callback handler.

Mike Christie (1):
  qla2xxx: Drop srb reference before waiting for completion.

 drivers/scsi/qla2xxx/qla_attr.c |    4 +
 drivers/scsi/qla2xxx/qla_bsg.c  |  125 +++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h  |    2 +
 drivers/scsi/qla2xxx/qla_def.h  |    2 -
 drivers/scsi/qla2xxx/qla_gbl.h  |    1 +
 drivers/scsi/qla2xxx/qla_init.c |   28 +++---
 drivers/scsi/qla2xxx/qla_iocb.c |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c  |   21 +---
 drivers/scsi/qla2xxx/qla_os.c   |  207 +++++++++++++++++++--------------------
 9 files changed, 257 insertions(+), 137 deletions(-)

