From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: sym53c8xx_2: remove redundant assignment to retv
Date: Fri,  9 Aug 2019 18:59:32 +0100
Message-ID: <20190809175932.10197-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Variable retv is initialized to a value that is never read and it
is re-assigned later. The initialization is redundant and can be
removed.

Addresses-Coverity: ("Unused value")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/sym53c8xx_2/sym_nvram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.c b/drivers/scsi/sym53c8xx_2/sym_nvram.c
index dd3f07b31612..9dc17f1288f9 100644
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.c
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.c
@@ -648,7 +648,7 @@ static int sym_read_T93C46_nvram(struct sym_device *np, Tekram_nvram *nvram)
 {
 	u_char gpcntl, gpreg;
 	u_char old_gpcntl, old_gpreg;
-	int retv = 1;
+	int retv;
 
 	/* save current state of GPCNTL and GPREG */
 	old_gpreg	= INB(np, nc_gpreg);
-- 
2.20.1
