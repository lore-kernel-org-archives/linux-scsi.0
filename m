From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 39/41] scsi: sym53c8xx_2: sym_nvram: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:34:17 -0600
Message-ID: <5e410e73a46bb5722617d4060bd5d92ca5be34bd.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/sym53c8xx_2/sym_nvram.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/sym53c8xx_2/sym_nvram.c b/drivers/scsi/sym53c8xx_2/sym_nvram.c
index 5662fbb3ff60..0d37b4f07b5e 100644
--- a/drivers/scsi/sym53c8xx_2/sym_nvram.c
+++ b/drivers/scsi/sym53c8xx_2/sym_nvram.c
@@ -708,6 +708,7 @@ static int sym_read_Tekram_nvram (struct sym_device *np, Tekram_nvram *nvram)
 					  data, len);
 		if (!x)
 			break;
+		/* fall through */
 	default:
 		x = sym_read_T93C46_nvram(np, nvram);
 		break;
-- 
2.17.1
