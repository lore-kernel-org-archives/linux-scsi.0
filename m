From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 36/41] scsi: qla4xxx: ql4_os: mark expected switch
 fall-through
Date: Tue, 27 Nov 2018 22:33:43 -0600
Message-ID: <a118ae0eeeb3cdcd4846bc1031ea89ca62af1e00.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: QLogic-Storage-Upstream@qlogic.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that, in this particular case, I replaced "allow fall-through"
with a "fall through" annotation, which is what GCC is expecting to
find.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 1c702cd22359..7fd3491ea2d9 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -2876,7 +2876,7 @@ static int qla4xxx_session_get_param(struct iscsi_cls_session *cls_sess,
 						chap_tbl.secret_len);
 			}
 		}
-		/* allow fall-through */
+		/* fall through */
 	default:
 		return iscsi_session_get_param(cls_sess, param, buf);
 	}
-- 
2.17.1
