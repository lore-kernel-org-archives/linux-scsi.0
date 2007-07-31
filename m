From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [PATCH 45] drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion to kcalloc
Date: Tue, 31 Jul 2007 20:26:43 +0200
Message-ID: <200707312026.43947.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, james.smart@emulex.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_init.c | 65932 -> 65881 (-51 bytes)
 drivers/scsi/lpfc/lpfc_init.o | 219760 -> 219616 (-144 bytes)

 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_init.c	2007-07-26 13:07:42.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_init.c	2007-07-31 11:07:59.000000000 +0200
@@ -1280,11 +1280,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	uint32_t *HashWorking;
 	uint32_t *pwwnn = (uint32_t *) phba->wwnn;

-	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
+	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
 	if (!HashWorking)
 		return;

-	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
 	HashWorking[0] = HashWorking[78] = *pwwnn++;
 	HashWorking[1] = HashWorking[79] = *pwwnn;

