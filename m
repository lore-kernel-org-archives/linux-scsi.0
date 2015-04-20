From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/4] target: Fix several problems related to T10-PI support
Date: Tue, 21 Apr 2015 08:36:18 +0900
Message-ID: <1429572982-6809-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patchset aims to fix several problems related to T10-PI support.

These patches can be applied on top of Sagi's "[v1] Simlify dif_verify
routines and fixup fileio protection information code" patchset.

Akinobu Mita (4):
  target: ensure se_cmd->t_prot_sg is allocated when required
  target: Abandon odd SG mapping for data transfer memory
  target: Fix sbc_dif_generate() for WRITE SAME
  target/file: enable WRITE SAME when protection info is enabled

 drivers/target/target_core_file.c      | 13 +++++----
 drivers/target/target_core_sbc.c       | 40 ++++++++++++++++++++++++--
 drivers/target/target_core_transport.c | 51 ++++++++++++++++++++--------------
 include/target/target_core_backend.h   |  2 +-
 include/target/target_core_base.h      |  1 +
 5 files changed, 78 insertions(+), 29 deletions(-)

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1
