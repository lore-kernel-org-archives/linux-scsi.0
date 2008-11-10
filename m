From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix for build warning
Date: Mon, 10 Nov 2008 15:53:20 -0800 (PST)
Message-ID: <alpine.OSX.1.00.0811101547560.2000@n4012av5rky081.qlogic.org>
References: <200811071744.mA7HiJaf012195@hera.kernel.org> <alpine.OSX.1.00.0811101211050.1560@n4012av5rky081.qlogic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:24854 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528AbYKJXxV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Nov 2008 18:53:21 -0500
In-Reply-To: <alpine.OSX.1.00.0811101211050.1560@n4012av5rky081.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, linux-scsi@vger.kernel.org

Thanks Stephen for pointing it out. The updated patch goes here.

Thanks,
Anirban

Signed-off-by: Anirban Chakraborty <anirban.chakraborty@qlogic.com>

---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 05db166..9830fcb 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -1563,7 +1563,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 	char pci_info[30];
 	char fw_str[30];
 	struct scsi_host_template *sht;
-	int bars, mem_only, max_id = 0;
+	int bars, max_id, mem_only = 0;
 	uint16_t req_length = 0, rsp_length = 0;
 
 	bars = pci_select_bars(pdev, IORESOURCE_MEM | IORESOURCE_IO);

