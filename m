From: madhu.iyengar@qlogic.com
Subject: [PATCH 00/10] qla2xxx: Updates for scsi-misc-2.6.
Date: Fri,  3 Sep 2010 15:20:47 -0700
Message-ID: <1283552457-4497-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:39312 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753086Ab0ICW05 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Sep 2010 18:26:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply these patches.

Giridhar Malavali (6):
  qla2xxx: Don't issue set or get port param MBC if port is not online.
  qla2xxx: Pass first 64 bytes of MBX information when vendor commands
    fail.
  qla2xxx: Return proper fabric name based on device state.
  qla2xxx: Cleanup some dead-code and make some functions static.
  qla2xxx: Clear local references of rport on device loss timeout
    notification from FC transport.
  qla2xxx: Increase SG table size to support large IO size per scsi
    command.

Lalit Chandivade (2):
  qla2xxx: Added AER support for ISP82xx.
  qla2xxx: Update to AER support, do early abort commands.

Madhuranath Iyengar (1):
  qla2xxx: Handle MPI timeout indicated by AE8002

Saurav Kashyap (1):
  qla2xxx: AER Support-Return recovered from mmio_enable function for
    82XX.

 drivers/scsi/qla2xxx/qla_attr.c |   28 ++--
 drivers/scsi/qla2xxx/qla_bsg.c  |    7 +-
 drivers/scsi/qla2xxx/qla_def.h  |    8 +
 drivers/scsi/qla2xxx/qla_gbl.h  |   15 +-
 drivers/scsi/qla2xxx/qla_init.c |   54 +++++-
 drivers/scsi/qla2xxx/qla_isr.c  |    8 +-
 drivers/scsi/qla2xxx/qla_mbx.c  |   66 +++++++-
 drivers/scsi/qla2xxx/qla_nx.c   |  392 ++++++++++++++++++++-------------------
 drivers/scsi/qla2xxx/qla_nx.h   |    5 +
 drivers/scsi/qla2xxx/qla_os.c   |  151 +++++++++++++++-
 10 files changed, 497 insertions(+), 237 deletions(-)

