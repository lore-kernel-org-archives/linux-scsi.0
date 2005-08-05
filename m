From: Alex Aizman <itn780@yahoo.com>
Subject: [ANNOUNCE 5/7] open-iscsi/linux-iscsi-5 Initiator: open-iscsi-Makefile.patch
Date: Thu, 04 Aug 2005 19:31:27 -0700
Message-ID: <42F2CF7F.2010508@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp018.mail.yahoo.com ([216.136.174.115]:164 "HELO
	smtp018.mail.yahoo.com") by vger.kernel.org with SMTP
	id S262819AbVHECbf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2005 22:31:35 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "David S. Miller" <davem@davemloft.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

	open-iscsi-Makefile.patch - drivers/scsi/Makefile changes.

	Signed-off-by: Alex Aizman <itn780@yahoo.com>
	Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
	Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -30,6 +30,7 @@ obj-$(CONFIG_SCSI_SPI_ATTRS)	+= scsi_tra
 obj-$(CONFIG_SCSI_FC_ATTRS) 	+= scsi_transport_fc.o
 obj-$(CONFIG_SCSI_ISCSI_ATTRS)	+= scsi_transport_iscsi.o
 
+obj-$(CONFIG_ISCSI_TCP) 	+= iscsi_tcp.o
 obj-$(CONFIG_SCSI_AMIGA7XX)	+= amiga7xx.o	53c7xx.o
 obj-$(CONFIG_A3000_SCSI)	+= a3000.o	wd33c93.o
 obj-$(CONFIG_A2091_SCSI)	+= a2091.o	wd33c93.o


