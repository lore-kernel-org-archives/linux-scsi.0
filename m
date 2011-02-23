From: madhu.iyengar@qlogic.com
Subject: [PATCH 00/13] qla2xxx: Updates for scsi-misc-2.6
Date: Wed, 23 Feb 2011 15:27:05 -0800
Message-ID: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52599 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754989Ab1BWXa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please add these patches. Thanks.

Andrew Vasquez (5):
  qla2xxx: Pass right CT command string for CT status processing.
  qla2xxx: Clear any stale login-states during an adapter reset.
  qla2xxx: Adjust FCP_RSP response-info field check after TMF
    completion.
  qla2xxx: Propagate block-layer tags on submitted I/Os.
  qla2xxx: Check return value of fc_block_scsi_eh()

Chad Dupuis (1):
  qla2xxx: Fix array subscript is above array bounds in
    qla2xx_build_scsi_type_6_iocbs().

Giridhar Malavali (4):
  qla2xxx: Reinitialize the device initialize timeout value after reset
    on ISP82xx.
  qla2xxx: Display nport_id when any SNS command fails.
  qla2xxx: Abort pending commands for faster recovery during ISP reset.
  qla2xxx: Don't wait for active mailbox command completion when
    firmware is hung.

Madhuranath Iyengar (2):
  qla2xxx: Remove host_lock in queuecommand function
  qla2xxx: Update version number to 8.03.07.00

Saurav Kashyap (1):
  qla2xxx: The ISP82XX should be online while waiting for commands
    completion.

 drivers/scsi/qla2xxx/qla_def.h     |    9 +-
 drivers/scsi/qla2xxx/qla_gbl.h     |    1 +
 drivers/scsi/qla2xxx/qla_gs.c      |   21 +++--
 drivers/scsi/qla2xxx/qla_init.c    |   41 ++++++--
 drivers/scsi/qla2xxx/qla_iocb.c    |   52 ++++++++++-
 drivers/scsi/qla2xxx/qla_mbx.c     |   45 ++++-----
 drivers/scsi/qla2xxx/qla_nx.c      |  191 +++++++++++++++++++++++++++---------
 drivers/scsi/qla2xxx/qla_os.c      |   57 ++++++-----
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 9 files changed, 301 insertions(+), 120 deletions(-)

