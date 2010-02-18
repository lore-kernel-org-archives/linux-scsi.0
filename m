From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/8] qla2xxx: Updates for scsi-misc-2.6.
Date: Thu, 18 Feb 2010 10:07:22 -0800
Message-ID: <1266516450-472-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:54290 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1751364Ab0BRSHd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Feb 2010 13:07:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

James,

Please apply following patches.

Andrew Vasquez (4):
  qla2xxx: Correct EH bus-reset handling.
  qla2xxx: Correct use-after-free issue in terminate_rport_io callback.
  qla2xxx: Correct loop-resync issues during SNS scans.
  qla2xxx: Add firmware ETS burst support.

Giridhar Malavali (2):
  qla2xxx: Proper clean-up of BSG requests when request times out.
  qla2xxx: Update version number to 8.03.02-k1.

Richard Lary (1):
  qla2xxx: EEH: Restore PCI saved state during pci slot reset.

Sarang Radke (1):
  qla2xxx: Initialize payload receive lenght in failure path of vendor
    commands

 drivers/scsi/qla2xxx/qla_attr.c    |  128 +++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_gbl.h     |    2 +-
 drivers/scsi/qla2xxx/qla_init.c    |   18 +++++-
 drivers/scsi/qla2xxx/qla_os.c      |   91 +++++++++++---------------
 drivers/scsi/qla2xxx/qla_version.h |    4 +-
 5 files changed, 112 insertions(+), 131 deletions(-)

