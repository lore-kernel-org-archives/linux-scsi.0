From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Delete trailing full stop
Date: Thu, 17 Nov 2005 11:13:43 -0700
Message-ID: <20051117181343.GD17171@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38306 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S964802AbVKQSNq
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2005 13:13:46 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


None of the other domain validation messages have a trailing full stop,
so I don't see why this one should.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 718a2bc..ec7bb70 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -1031,7 +1031,7 @@ void spi_display_xfer_agreement(struct s
 			 tp->hold_mcs ? " HMCS" : "",
 			 tmp, tp->offset);
 	} else {
-		dev_info(&starget->dev, "%sasynchronous.\n",
+		dev_info(&starget->dev, "%sasynchronous\n",
 				tp->width ? "wide " : "");
 	}
 }
