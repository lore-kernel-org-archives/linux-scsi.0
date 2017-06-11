From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH 0/2] Fix a return value + some cleanups
Date: Sun, 11 Jun 2017 08:40:17 +0200
Message-ID: <cover.1497162751.git.christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@cavium.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

This patch serie first fixes a case where an error code was missing.
The other path is just a cleanup in the same area.

Christophe JAILLET (2):
  scsi: qedi: Fix a return value in case of error in
    'qedi_alloc_global_queues'
  scsi: qedi: Use 'dma_zalloc_coherent' to reduce code verbosity.

 drivers/scsi/qedi/qedi_main.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

-- 
2.11.0
