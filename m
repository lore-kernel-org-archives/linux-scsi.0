From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH v1 10/10] mlx4_fc: Enable FC over Ethernet/Infiniband
 drivers
Date: Mon, 16 Aug 2010 16:51:37 -0700
Message-ID: <20100816165137.d006efd0.randy.dunlap@oracle.com>
References: <4C69B8E1.80702@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:23533 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0HPXxe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Aug 2010 19:53:34 -0400
In-Reply-To: <4C69B8E1.80702@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vu Pham <vuhuong@mellanox.com>
Cc: Roland Dreier <rdreier@cisco.com>, OpenFabrics EWG <ewg@openfabrics.org>, Linux RDMA <linux-rdma@vger.kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>

On Mon, 16 Aug 2010 15:17:05 -0700 Vu Pham wrote:

>  {hm, no text to reply to;  oh, the patch is an attachment; please don't do that}


(copy-paste here:)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 158284f..3573cee 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -687,6 +687,28 @@ config FCOE_FNIC
 	  <file:Documentation/scsi/scsi.txt>.
 	  The module will be called fnic.
 
+config MLX4_FC
+	tristate "Mellanox FC module"
+	depends on MLX4_EN

	depends on 
+	select LIBFC
+	select LIBFCOE
+	help
+	  Fibre Channel over Ethernet/Infiniband module
+
+	  This is support for the Mellanox ConnectX/ConnectX-2 HCAs
+	  The module will be called mlx4_fc

End both lines above with periods (".").

+
+config MLX4_FCOIB
+	tristate "Mellanox FCoIB discovery module"
+	depends on INFINIBAND
+	select MLX4_FC
+	help
+	  Fibre Channel over Infiniband discovery module
+
+	  The module FIP-alike to discover BridgeX gateways in the
+	  Infiniband fabric

end sentence with ".".

What does "FIP-alike" mean?  and fix grammar:

	  This module attempts to discover BridgeX gateways in the
	  Infiniband fabric.
?


+	  The module will be called mlx4_fc
+

end sentence with ".".


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
