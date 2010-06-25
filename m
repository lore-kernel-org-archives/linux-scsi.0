From: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] ipr: change endian swap key to match hardware spec
 change
Date: Thu, 24 Jun 2010 17:00:59 -0700
Message-ID: <4C23F1BB.1010600@linux.vnet.ibm.com>
References: <20100624203107.468479055@linux.vnet.ibm.com> <4C23C15F.3090000@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44486 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0FYABD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2010 20:01:03 -0400
Received: from d01relay01.pok.ibm.com (d01relay01.pok.ibm.com [9.56.227.233])
	by e8.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o5ONnFiS014977
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 19:49:15 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o5P0121Z124736
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 20:01:02 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o5P011jN018301
	for <linux-scsi@vger.kernel.org>; Thu, 24 Jun 2010 21:01:02 -0300
In-Reply-To: <4C23C15F.3090000@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Brian King <brking@linux.vnet.ibm.com>



On 06/24/2010 01:34 PM, Wayne Boyer wrote:
> The value used to change the endian representation on the new adapters has
> changed.  This patch updates that value.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: b/drivers/scsi/ipr.h
> ===================================================================
> --- a/drivers/scsi/ipr.h	2010-06-23 11:21:57.000000000 -0700
> +++ b/drivers/scsi/ipr.h	2010-06-23 11:22:08.000000000 -0700
> @@ -1257,7 +1257,7 @@ struct ipr_interrupt_offsets {
>  	unsigned long dump_addr_reg;
>  	unsigned long dump_data_reg;
> 
> -#define IPR_ENDIAN_SWAP_KEY		0x000C0C00
> +#define IPR_ENDIAN_SWAP_KEY		0x000B0B00

The original patch has the wrong value.  I mistook "8" for "B" in the
spec.  The corrected patch is below.

---

The value used to change the endian representation on the new adapters has
changed.  This patch updates that value.

Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
---

 drivers/scsi/ipr.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: b/drivers/scsi/ipr.h
===================================================================
--- a/drivers/scsi/ipr.h	2010-06-23 11:21:57.000000000 -0700
+++ b/drivers/scsi/ipr.h	2010-06-24 16:45:34.000000000 -0700
@@ -1257,7 +1257,7 @@ struct ipr_interrupt_offsets {
 	unsigned long dump_addr_reg;
 	unsigned long dump_data_reg;

-#define IPR_ENDIAN_SWAP_KEY		0x000C0C00
+#define IPR_ENDIAN_SWAP_KEY		0x00080800
 	unsigned long endian_swap_reg;
 };
