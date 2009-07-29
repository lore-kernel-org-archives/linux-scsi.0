From: giridhar.malavali@qlogic.com
Subject: [PATCH 00/14] qla2xxx: fixes for 2.6.31-rc3 [8.03.01-k5/K6/K7]
Date: Wed, 29 Jul 2009 11:03:49 -0700
Message-ID: <1248890643-761-1-git-send-email-giridhar.malavali@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:35908 "EHLO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751195AbZG2SEE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jul 2009 14:04:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: giridhar.malavali@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Giridhar Malavali <giridhar.malavali@qlogic.com>

Please apply...

Andrew Vasquez (3):
  qla2xxx: Correctly handle 'global port-unavailable' AEN.
  qla2xxx: Fix endian issues on PPC platfrom for NPIV.
  qla2xxx: ISP21xx/22xx do not support FDMI registrations.  (fixed)

Anirban Chakraborty (2):
  qla2xxx: Fix to ensure driver works in sinlge queue mode if
    multiqueue fails.
  qla2xxx: Fix a bug that clears the interrupt status register for the
    base queue

Giridhar Malavali (3):
  qla2xxx: Update version number to 8.03.01-k5
  qla2xxx: Update version number to 8.03.01-k6
  qla2xxx: Update version number to 8.03.01-k7

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

 drivers/scsi/qla2xxx/qla_attr.c    |    4 +-
 drivers/scsi/qla2xxx/qla_def.h     |    1 +
 drivers/scsi/qla2xxx/qla_fw.h      |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c      |    4 ++
 drivers/scsi/qla2xxx/qla_init.c    |    5 +--
 drivers/scsi/qla2xxx/qla_iocb.c    |    2 +-
 drivers/scsi/qla2xxx/qla_isr.c     |   55 +++++++++++++++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_mbx.c     |    7 ++--
 drivers/scsi/qla2xxx/qla_mid.c     |    3 ++
 drivers/scsi/qla2xxx/qla_os.c      |   21 +++++++++++--
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 11 files changed, 87 insertions(+), 19 deletions(-)

