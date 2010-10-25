From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: PATCH[1/1] pmcraid driver fix to remove duplicate struct member
Date: Mon, 25 Oct 2010 15:41:54 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.1010251536390.29896@rslab235.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:46484 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751265Ab0JZAfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Oct 2010 20:35:53 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com
Cc: anil_ravindranath@pmc-sierra.com, andi@firstfloor.org


The following patch fixes removal of a duplicate struct member definition.

Signed-off-by: Anil Ravindranath<anil_ravindranath@pmc-sierra.com>

pmcraid.h |    1 -
 1 file changed, 1 deletion(-)

--- scsi-misc-2.6.orig/drivers/scsi/pmcraid.h	2010-10-25 17:24:23.000000000 -0700
+++ scsi-misc-2.6/drivers/scsi/pmcraid.h	2010-10-25 17:23:51.000000000 -0700
@@ -568,7 +568,6 @@
 	struct pmcraid_control_block *ioa_cb;
 	dma_addr_t ioa_cb_bus_addr;
 	dma_addr_t dma_handle;
-	u8 *sense_buffer;
 
 	/* pointer to mid layer structure of SCSI commands */
 	struct scsi_cmnd *scsi_cmd;
