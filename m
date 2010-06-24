From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: [PATCH 2/2] ipr: change endian swap key to match hardware spec change
Date: Thu, 24 Jun 2010 13:34:39 -0700
Message-ID: <4C23C15F.3090000@linux.vnet.ibm.com>
References: <20100624203107.468479055@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:33257 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab0FXUfC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jun 2010 16:35:02 -0400
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by e37.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5OKXBZ0016377
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 14:33:11 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5OKYhIb063722
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 14:34:44 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5OKblsR021377
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 14:37:48 -0600
In-Reply-To: <20100624203107.468479055@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>

The value used to change the endian representation on the new adapters has
changed.  This patch updates that value.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-06-23 11:21:57.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-06-23 11:22:08.000000000 -0700
@@ -1257,7 +1257,7 @@ struct ipr_interrupt_offsets {
 	unsigned long dump_addr_reg;
 	unsigned long dump_data_reg;

-#define IPR_ENDIAN_SWAP_KEY		0x000C0C00
+#define IPR_ENDIAN_SWAP_KEY		0x000B0B00
 	unsigned long endian_swap_reg;
 };


