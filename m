From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Subject: [PATCH] tgt: use KMEM_CACHE
Date: Wed, 24 Oct 2007 19:57:55 -0700
Message-ID: <20071024195755.14e9c37f@laptopd505.fenrus.org>
References: <20071024235611B.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39565 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbXJYDBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 23:01:23 -0400
In-Reply-To: <20071024235611B.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Thu, 25 Oct 2007 01:21:29 +0900
FUJITA Tomonori <tomof@acm.org> wrote:

> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/scsi/scsi_tgt_lib.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
> index deea3cd..7abef1a 100644
> --- a/drivers/scsi/scsi_tgt_lib.c
> +++ b/drivers/scsi/scsi_tgt_lib.c
> @@ -641,9 +641,7 @@ static int __init scsi_tgt_init(void)
>  {
>  	int err;
>  
> -	scsi_tgt_cmd_cache = kmem_cache_create("scsi_tgt_cmd",
> -					       sizeof(struct
> scsi_tgt_cmd),
> -					       0, 0, NULL);
> +	scsi_tgt_cmd_cache =  KMEM_CACHE(scsi_tgt_cmd, 0);


Hi,

I have a question that is not described in your change log: why would
you want to do this change? kmem_cache_create() is THE linux API to
achieve this.... why would you not want to use it?? I'm sure you have a
good reason for this change, but I can't figure out what that is from
the changelog of your patch.

Greetings,
   Arjan van de Ven
