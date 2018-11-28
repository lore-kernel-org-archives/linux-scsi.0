From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 19/41] scsi: isci: remote_node_context: mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:30:11 -0600
Message-ID: <b54e3cf608d656ce6d8445becd105d1613325198.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Notice that, in this particular case, a dash is added as a token in
order to separate the "Fall through" annotations from the rest of
the comment on the same line, which is what GCC is expecting to find.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/isci/remote_node_context.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/remote_node_context.c b/drivers/scsi/isci/remote_node_context.c
index e3f2a5359d71..474a43460963 100644
--- a/drivers/scsi/isci/remote_node_context.c
+++ b/drivers/scsi/isci/remote_node_context.c
@@ -601,9 +601,9 @@ enum sci_status sci_remote_node_context_suspend(
 				 __func__, sci_rnc);
 			return SCI_FAILURE_INVALID_STATE;
 		}
-		/* Fall through and handle like SCI_RNC_POSTING */
+		/* Fall through - and handle like SCI_RNC_POSTING */
 	case SCI_RNC_RESUMING:
-		/* Fall through and handle like SCI_RNC_POSTING */
+		/* Fall through - and handle like SCI_RNC_POSTING */
 	case SCI_RNC_POSTING:
 		/* Set the destination state to AWAIT - this signals the
 		 * entry into the SCI_RNC_READY state that a suspension
-- 
2.17.1
