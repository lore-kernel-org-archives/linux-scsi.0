From: madhu.iyengar@qlogic.com
Subject: [PATCH 00/14] qla2xxx: Updates for scsi-misc-2.6.
Date: Tue, 21 Dec 2010 16:00:13 -0800
Message-ID: <1292976027-12034-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:36142 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753262Ab0LVADX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2010 19:03:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

From: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>

James,

Please add these patches. Thanks.

Andrew Vasquez (4):
  qla2xxx: Populate FCP_PRIO location for no *FLT* case
  qla2xxx: Add sysfs node for displaying board temperature.
  qla2xxx: Don't perform a BIG_HAMMER if Get-ID (0x20) mailbox command
    fails on CNAs.
  qla2xxx: Display mailbox register 4 during 8012 AEN for ISP82XX
    parts.

Dan Carpenter (1):
  qla2xxx: list cursors are not null

Giridhar Malavali (4):
  qla2xxx: Code cleanup to remove unwanted comments and code.
  qla2xxx: Remove code to not reset ISP82xx on failure.
  qla2xxx: Fix to avoid recursive lock failure during BSG timeout.
  qla2xxx: Use sg_next to fetch next sg element while walking sg list.

Joe Carnuccio (2):
  qla2xxx: Fixed zero test on new_config in qla2x00_process_loopback().
  qla2xxx: Remove redundant module parameter permission bits

Madhuranath Iyengar (2):
  qla2xxx: Update FCP priority information to firmware before sending
    IOs
  qla2xxx: Fix for memory wedge on fw halt for ISP82XX

Saurav Kashyap (1):
  qla2xxx: Added support for quiescence mode for ISP82xx.

 drivers/scsi/qla2xxx/qla_attr.c |   27 +++++
 drivers/scsi/qla2xxx/qla_bsg.c  |    6 +-
 drivers/scsi/qla2xxx/qla_def.h  |    4 +
 drivers/scsi/qla2xxx/qla_gbl.h  |    8 ++-
 drivers/scsi/qla2xxx/qla_init.c |   89 ++++++++++++++--
 drivers/scsi/qla2xxx/qla_isr.c  |    2 +
 drivers/scsi/qla2xxx/qla_mbx.c  |   67 ++++++++++++-
 drivers/scsi/qla2xxx/qla_nx.c   |  217 +++++++++++++++++++++++++++++++-------
 drivers/scsi/qla2xxx/qla_nx.h   |    2 -
 drivers/scsi/qla2xxx/qla_os.c   |   63 +++++++-----
 drivers/scsi/qla2xxx/qla_sup.c  |   11 ++-
 11 files changed, 408 insertions(+), 88 deletions(-)

