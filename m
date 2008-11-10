From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: [PATCH] qla2xxx: Fix for build warning
Date: Mon, 10 Nov 2008 12:26:23 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0811101211050.1560@n4012av5rky081.qlogic.org>
References: <200811071744.mA7HiJaf012195@hera.kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <200811071744.mA7HiJaf012195@hera.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Here is the patch that takes care of the build warning due to a 
missing initializer for a local variable in qla probe function.
Please apply.

Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 05db166..9aa24a4 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1563,7 +1563,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
-	int bars, mem_only, max_id = 0;
+	int bars, mem_only = 0, max_id = 0;
 	uint16_t req_length = 0, rsp_length = 0;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);
