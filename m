From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Date: Fri, 19 Oct 2007 15:04:31 +1000
Message-ID: <20071019150431.996522c5.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:54366 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXJSFEk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Oct 2007 01:04:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

At least for now.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 30905ce..325533c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -523,6 +523,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
 	depends on ISA || EISA || PCI
+	depends on VIRT_TO_BUS
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
-- 
1.5.3.4

