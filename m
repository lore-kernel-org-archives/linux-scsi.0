From: giridhar.malavali@qlogic.com
Subject: [PATCH 0/9] qla2xxx: fixes for 2.6.31-rc3 [8.03.01-k5]
Date: Tue, 21 Jul 2009 12:03:36 -0700
Message-ID: <1248203025-507-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:37714 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752077AbZGUTDq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jul 2009 15:03:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply....

Andrew Vasquez (2):
  qla2xxx: Correctly handle 'global port-unavailable' AEN.
  qla2xxx: Fix endian issues on PPC platfrom for NPIV.

Giridhar Malavali (1):
  qla2xxx: Update version number to 8.03.01-k5

Lalit Chandivade (1):
  qla2xxx: Process DPC requests within valid Fabric topologies.

Ravi Anand (1):
  qla2xxx: Modified the driver to pass the residaul UNDERRUN status

Santosh Vernekar (3):
  qla2xxx: Skip RSCN processing if the event is global and vp_idx index
  qla2xxx: Mark all devices as lost when fc port is marked
  qla2xxx: Handle RSCN's per master/slave vn-port basis.

Shyam Sundar (1):
  qla2xxx: Corrected one of the IOCB structure to be 64 bytes size

 drivers/scsi/qla2xxx/qla_fw.h      |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   52 +++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |    3 +-
 drivers/scsi/qla2xxx/qla_mid.c     |    3 ++
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 5 files changed, 56 insertions(+), 6 deletions(-)

