From: Suman Tripathi <stripathi@apm.com>
Subject: [PATCH v4 4/4] ata: Removing NCQ support from the APM X-Gene SoC AHCI SATA Host Controller driver.
Date: Tue, 29 Jul 2014 12:24:52 +0530
Message-ID: <1406616892-30273-5-git-send-email-stripathi@apm.com>
References: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1406616892-30273-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Suman Tripathi <stripathi@apm.com>, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

This patch removes the NCQ support from the APM X-Gene SoC AHCI
Host Controller driver as it doesn't support it.

Signed-off-by: Loc Ho <lho@apm.com>
Signed-off-by: Suman Tripathi <stripathi@apm.com>
---
 drivers/ata/ahci_xgene.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
index 1d48371..4496ddf 100644
--- a/drivers/ata/ahci_xgene.c
+++ b/drivers/ata/ahci_xgene.c
@@ -310,8 +310,8 @@ static struct ata_port_operations xgene_ahci_ops = {
 };

 static const struct ata_port_info xgene_ahci_port_info = {
-	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_YES_NCQ),
-	.flags = AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	AHCI_HFLAGS(AHCI_HFLAG_NO_PMP | AHCI_HFLAG_NO_NCQ),
+	.flags = AHCI_FLAG_COMMON,
 	.pio_mask = ATA_PIO4,
 	.udma_mask = ATA_UDMA6,
 	.port_ops = &xgene_ahci_ops,
--
1.8.2.1

