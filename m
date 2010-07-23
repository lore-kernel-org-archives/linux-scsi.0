From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [patch 01/27] scsi: add __init/__exit macros to ibmvstgt.c
Date: Fri, 23 Jul 2010 10:22:06 -0500
Message-ID: <4C49B39E.3080206@linux.vnet.ibm.com>
References: <201007202228.o6KMSf0K021708@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39570 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906Ab0GWPWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 Jul 2010 11:22:22 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e4.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id o6NF8DXC004574
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2010 11:08:13 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id o6NFM9aU1577060
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2010 11:22:09 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id o6NFM6gl008138
	for <linux-scsi@vger.kernel.org>; Fri, 23 Jul 2010 12:22:09 -0300
In-Reply-To: <201007202228.o6KMSf0K021708@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, peterhuewe@gmx.de, James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au

Acked-by: Brian King <brking@linux.vnet.ibm.com>

On 07/20/2010 05:28 PM, akpm@linux-foundation.org wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> Add the __init and __exit macros to the module_init / module_exit
> functions from drivers/scsi/ibmvscsi/ibmvstgt.c
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: James Bottomley <James.Bottomley@SteelEye.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvstgt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgtc drivers/scsi/ibmvscsi/ibmvstgt.c
> --- a/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgtc
> +++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
> @@ -956,7 +956,7 @@ static struct srp_function_template ibmv
>  	.it_nexus_response = ibmvstgt_it_nexus_response,
>  };
> 
> -static int ibmvstgt_init(void)
> +static int __init ibmvstgt_init(void)
>  {
>  	int err = -ENOMEM;
> 
> @@ -987,7 +987,7 @@ release_transport:
>  	return err;
>  }
> 
> -static void ibmvstgt_exit(void)
> +static void __exit ibmvstgt_exit(void)
>  {
>  	printk("Unregister IBM virtual SCSI driver\n");
> 
> _
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


