From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] final round of SCSI updates for the 4.12+ merge window
Date: Sat, 15 Jul 2017 22:56:22 -0700
Message-ID: <1500184582.2733.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49578 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751229AbdGPF40 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 16 Jul 2017 01:56:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is actually just a small set of mainly bug fixes for the original
merge window code plus a few trivial updates and qedi boot from SAN
support feature patch.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Colin Ian King (4):
      scsi: hisi_sas: make several const arrays static
      scsi: qedf: fix spelling mistake: "offlading" -> "offloading"
      scsi: qedi: fix another spelling mistake: "alloction" -> "allocation"
      scsi: isci: fix typo in function names

Dan Carpenter (3):
      scsi: libfc: pass an error pointer to fc_disc_error()
      scsi: qla2xxx: Off by one in qlt_ctio_to_cmd()
      scsi: cxlflash: return -EFAULT if copy_from_user() fails

Johannes Thumshirn (1):
      scsi: sg: fix SG_DXFER_FROM_DEV transfers

Nilesh Javali (1):
      scsi: qedi: Add support for Boot from SAN over iSCSI offload

Paolo Bonzini (1):
      scsi: virtio_scsi: always read VPD pages for multiqueue too

And the diffstat:

 drivers/scsi/cxlflash/main.c           |  11 +-
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  10 +-
 drivers/scsi/isci/request.c            |  14 +-
 drivers/scsi/libfc/fc_disc.c           |   2 +-
 drivers/scsi/qedf/qedf_main.c          |   2 +-
 drivers/scsi/qedi/qedi.h               |  17 ++
 drivers/scsi/qedi/qedi_fw.c            |   2 +-
 drivers/scsi/qedi/qedi_main.c          | 419 +++++++++++++++++++++++++++++++++
 drivers/scsi/qedi/qedi_nvm_iscsi_cfg.h | 210 +++++++++++++++++
 drivers/scsi/qla2xxx/qla_target.c      |   2 +-
 drivers/scsi/sg.c                      |   5 +-
 drivers/scsi/virtio_scsi.c             |   1 +
 12 files changed, 674 insertions(+), 21 deletions(-)
 create mode 100644 drivers/scsi/qedi/qedi_nvm_iscsi_cfg.h

James
