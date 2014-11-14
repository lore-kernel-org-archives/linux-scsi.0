From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 05/13] hpsa: remove 'action required' phrasing
Date: Fri, 14 Nov 2014 17:26:48 -0600
Message-ID: <20141114232648.20808.2008.stgit@don-ProLiant-MicroServer-Gen8>
References: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13299 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422934AbaKNXZO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Nov 2014 18:25:14 -0500
In-Reply-To: <20141114231145.20808.76898.stgit@don-ProLiant-MicroServer-Gen8>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org, webb.scales@hp.com, james.bottomley@parallels.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <stephenmcameron@gmail.com>

In the case of LUN data changing, the driver will
auto rescan and so it's not even true that "action" is
"required".

Remove "action required" phrases from warning messages and
replace with description phrases.

Signed-off-by: Don Brace <don.brace@pmcs.com>
Reviewed-by: Stephen M. Cameron <stephenmcameron@gmail.com>
Reviewed-by: Joe Handzik <joseph.t.handzik@hp.com>
Reviewed-by: Webb Scales <webb.scales@hp.com>
---
 drivers/scsi/hpsa.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f57081c..538fdea 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -276,12 +276,12 @@ static int check_for_unit_attention(struct ctlr_info *h,
 			"detected, command retried\n", h->ctlr);
 		break;
 	case LUN_FAILED:
-		dev_warn(&h->pdev->dev, HPSA "%d: LUN failure "
-			"detected, action required\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			HPSA "%d: LUN failure detected\n", h->ctlr);
 		break;
 	case REPORT_LUNS_CHANGED:
-		dev_warn(&h->pdev->dev, HPSA "%d: report LUN data "
-			"changed, action required\n", h->ctlr);
+		dev_warn(&h->pdev->dev,
+			HPSA "%d: report LUN data changed\n", h->ctlr);
 	/*
 	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the external
 	 * target (array) devices.

