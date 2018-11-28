From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 18/41] scsi: isci: remote_device: Mark expected switch
 fall-throughs
Date: Tue, 27 Nov 2018 22:30:01 -0600
Message-ID: <de14fd0d7246aa4ac19dcc48491641890c2c289d.1543374820.git.gustavo@embeddedor.com>
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
order to separate the "fall through" annotations from the rest of
the comment on the same line, which is what GCC is expecting to find.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/isci/remote_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/isci/remote_device.c b/drivers/scsi/isci/remote_device.c
index cc51f38b116d..9d29edb9f590 100644
--- a/drivers/scsi/isci/remote_device.c
+++ b/drivers/scsi/isci/remote_device.c
@@ -310,7 +310,7 @@ static void isci_remote_device_not_ready(struct isci_host *ihost,
 		/* Kill all outstanding requests for the device. */
 		sci_remote_device_terminate_requests(idev);
 
-		/* Fall through into the default case... */
+		/* Fall through - into the default case... */
 	default:
 		clear_bit(IDEV_IO_READY, &idev->flags);
 		break;
@@ -593,7 +593,7 @@ enum sci_status sci_remote_device_event_handler(struct isci_remote_device *idev,
 
 			break;
 		}
-	/* Else, fall through and treat as unhandled... */
+		/* fall through - and treat as unhandled... */
 	default:
 		dev_dbg(scirdev_to_dev(idev),
 			"%s: device: %p event code: %x: %s\n",
-- 
2.17.1
