From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 08/41] scsi: be2iscsi: be_main: Mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:27:00 -0600
Message-ID: <ca994231ba2101ba489ee7b18862a10a8c9dad7e.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1357387 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index effb6fc95af4..b6449da1320c 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1539,6 +1539,7 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
 		break;
 	case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
 		error = 1;
+		/* fall through */
 	case UNSOL_DATA_NOTIFY:
 		pasync_handle = pasync_ctx->async_entry[ci].data;
 		break;
-- 
2.17.1
