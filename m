From: Peter Huewe <PeterHuewe@gmx.de>
Subject: Re: [patch 01/19] scsi: add __init/__exit macros to ibmvstgt.c
Date: Tue, 22 Dec 2009 08:06:32 +0100
Message-ID: <200912220806.32904.PeterHuewe@gmx.de>
References: <200912220027.nBM0Rcrj005361@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:35744 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751741AbZLVHGg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Dec 2009 02:06:36 -0500
In-Reply-To: <200912220027.nBM0Rcrj005361@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, James.Bottomley@steeleye.com, fujita.tomonori@lab.ntt.co.jp, sfr@canb.auug.org.au, trivial@kernel.org

Am Dienstag 22 Dezember 2009 01:27:38 schrieb akpm@linux-foundation.org:
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
> diff -puN
>  drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvstgt
> c drivers/scsi/ibmvscsi/ibmvstgt.c ---
>  a/drivers/scsi/ibmvscsi/ibmvstgt.c~scsi-add-__init-__exit-macros-to-ibmvst
> gtc +++ a/drivers/scsi/ibmvscsi/ibmvstgt.c
> @@ -955,7 +955,7 @@ static struct srp_function_template ibmv
>  	.it_nexus_response = ibmvstgt_it_nexus_response,
>  };
> 
> -static int ibmvstgt_init(void)
> +static int __init ibmvstgt_init(void)
>  {
>  	int err = -ENOMEM;
> 
> @@ -986,7 +986,7 @@ release_transport:
>  	return err;
>  }
> 
> -static void ibmvstgt_exit(void)
> +static void __exit ibmvstgt_exit(void)
>  {
>  	printk("Unregister IBM virtual SCSI driver\n");
> 
> _
> 

Hi,

this patch is floating around for almost half a year (2009/06/23) and I was 
wondering if there is anything wrong with it, or why it doesn't get merged 
upstream.

I know the patch is really trivial and maybe not even worth this email, but in 
my opinion every single line counts :)

@James: Do you prefer if Jiri Kosina merges this one through his trivial tree?


Thanks,
Peter


