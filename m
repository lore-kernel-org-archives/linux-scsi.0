From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Make scsi_transport_spi.h includable by itself
Date: Tue, 13 Dec 2005 10:29:31 -0700
Message-ID: <20051213172931.GN9286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:27874 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750987AbVLMR3c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Dec 2005 12:29:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add forward declarations to allow scsi_transport_spi.h to be compiled by
itself.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/include/scsi/scsi_transport_spi.h b/include/scsi/scsi_transport_spi.h
index 6bdc4af..5c9b2e5 100644
--- a/include/scsi/scsi_transport_spi.h
+++ b/include/scsi/scsi_transport_spi.h
@@ -24,6 +24,9 @@
 #include <linux/transport_class.h>
 
 struct scsi_transport_template;
+struct scsi_target;
+struct scsi_device;
+struct Scsi_Host;
 
 struct spi_transport_attrs {
 	int period;		/* value in the PPR/SDTR command */
