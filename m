From: giridhar.malavali@qlogic.com
Subject: [PATCH 00/16] qla2xxx: Updates for scsi-misc-2.6.
Date: Tue,  4 May 2010 15:01:20 -0700
Message-ID: <1273010496-43045-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:47137 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1755150Ab0EDWBi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 May 2010 18:01:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James, 

Please apply these patches.

Andrew Vasquez (5):
  qla2xxx: Check for ISP84xx before processing to get 84xx firmware
    version.
  qla2xxx: Display proper link state for disconnected ports.
  qla2xxx: Further generalization of SRB CTX infrastructure.
  qla2xxx: Limit mailbox command contention for ADISC requests.
  qla2xxx: Cleanup FCP-command-status processing debug statements.

Arun Easi (1):
  qla2xxx: T10 DIF support added.

Giridhar Malavali (3):
  qla2xxx: Optionally disable target reset.
  qla2xxx: Updates to ISP82xx support.
  qla2xxx: Update version number to 8.03.03-k0.

Harish Zunjarrao (1):
  qla2xxx: Add char device to increase driver use count

Lalit Chandivade (2):
  qla2xxx: Clear error status after uncorrectable non-fatal errors.
  qla2xxx: ensure flash operation and host reset via sg_reset are
    mutually exclusive

Madhuranath Iyengar (2):
  qla2xxx: Provide common framework for BSG and IOCB commands.
  qla2xxx: Support for asynchronous TM and Marker IOCBs.

Mike Waychison (1):
  qla2xxx: Silence bogus warning by gcc for wrap and did.

Sarang Radke (1):
  qla2xxx: Add internal loopback support for 81XX

 drivers/scsi/qla2xxx/qla_attr.c    |   33 ++-
 drivers/scsi/qla2xxx/qla_bsg.c     |  206 ++++++++--
 drivers/scsi/qla2xxx/qla_bsg.h     |    7 +
 drivers/scsi/qla2xxx/qla_dbg.c     |   58 +++
 drivers/scsi/qla2xxx/qla_dbg.h     |   10 +
 drivers/scsi/qla2xxx/qla_def.h     |  167 +++++++--
 drivers/scsi/qla2xxx/qla_fw.h      |   47 ++-
 drivers/scsi/qla2xxx/qla_gbl.h     |   29 ++-
 drivers/scsi/qla2xxx/qla_init.c    |  387 ++++++++++++++----
 drivers/scsi/qla2xxx/qla_inline.h  |   16 +
 drivers/scsi/qla2xxx/qla_iocb.c    |  805 +++++++++++++++++++++++++++++++++++-
 drivers/scsi/qla2xxx/qla_isr.c     |  505 +++++++++++++----------
 drivers/scsi/qla2xxx/qla_mbx.c     |   76 ++++
 drivers/scsi/qla2xxx/qla_nx.c      |  205 +++++-----
 drivers/scsi/qla2xxx/qla_nx.h      |   15 +-
 drivers/scsi/qla2xxx/qla_os.c      |  196 ++++++++-
 drivers/scsi/qla2xxx/qla_version.h |    6 +-
 17 files changed, 2277 insertions(+), 491 deletions(-)

