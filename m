From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] scsi: mvumi: Use true and false for boolean values
Date: Sat, 4 Aug 2018 19:01:42 -0500
Message-ID: <20180805000141.GA18117@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Return statements in functions returning bool should use true or false
instead of an integer value.

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/mvumi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index b3cd9a6..a1a9787 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -82,9 +82,9 @@ static void tag_release_one(struct mvumi_hba *mhba, struct mvumi_tag *st,
 static bool tag_is_empty(struct mvumi_tag *st)
 {
 	if (st->top == 0)
-		return 1;
+		return true;
 	else
-		return 0;
+		return false;
 }
 
 static void mvumi_unmap_pci_addr(struct pci_dev *dev, void **addr_array)
-- 
2.7.4
