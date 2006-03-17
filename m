From: Brian King <brking@us.ibm.com>
Subject: [PATCH 01/15] libata: Setup nbytes in ata_sg_init_one
Date: Fri, 17 Mar 2006 17:03:55 -0600
Message-ID: <200603172303.k2HN3voJ028508@d01av02.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Setup nbytes in ata_sg_init_one to the total transfer length
of the command.

Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/libata-core.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN drivers/scsi/libata-core.c~libata_setup_nbytes drivers/scsi/libata-core.c
--- libata-dev/drivers/scsi/libata-core.c~libata_setup_nbytes	2006-03-17 15:35:26.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/libata-core.c	2006-03-17 15:35:26.000000000 -0600
@@ -2887,6 +2887,7 @@ void ata_sg_init_one(struct ata_queued_c
 	qc->n_elem = 1;
 	qc->orig_n_elem = 1;
 	qc->buf_virt = buf;
+	qc->nbytes = buflen;
 
 	sg = qc->__sg;
 	sg_init_one(sg, buf, buflen);
_
