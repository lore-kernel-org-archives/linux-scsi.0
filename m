From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/3] scsi: qedf: Fix a return value + some cleanups
Date: Sun, 11 Jun 2017 08:16:01 +0200
Message-ID: <cover.1497160148.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

This patch serie first fixes a case where an error code was missing.
The 2 other patches are just cleanups in the same area.

Christophe JAILLET (3):
  scsi: qedf: Fix a return value in case of error in
    'qedf_alloc_global_queues'
  scsi: qedf: Use 'dma_zalloc_coherent' to reduce code verbosity.
  scsi: qedf: Merge a few quoted strings split across lines

 drivers/scsi/qedf/qedf_main.c | 38 +++++++++++++-------------------------
 1 file changed, 13 insertions(+), 25 deletions(-)

-- 
2.11.0
