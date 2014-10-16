From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] aic7xxx: replace kmalloc/memset by kzalloc
Date: Thu, 16 Oct 2014 21:30:43 +0200
Message-ID: <54401CE3.8000307@free-electrons.com>
References: <1413486878-375-1-git-send-email-michael.opdenacker@free-electrons.com> <1413487720.15773.1.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413487720.15773.1.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: hare@suse.de, JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
List-Id: linux-scsi@vger.kernel.org

Hi Joe,

On 10/16/2014 09:28 PM, Joe Perches wrote:
> On Thu, 2014-10-16 at 21:14 +0200, Michael Opdenacker wrote:
>
>  
>  	/* Allocate SCB resources */
> -	scb_data->scbarray = kmalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC, GFP_ATOMIC);
> +	scb_data->scbarray = kzalloc(sizeof(struct scb) * AHC_SCB_MAX_ALLOC,
> +				GFP_ATOMIC);
>  	if (scb_data->scbarray == NULL)
>  		return (ENOMEM);
> -	memset(scb_data->scbarray, 0, sizeof(struct scb) * AHC_SCB_MAX_ALLOC);
>  
>  	/* Determine the number of hardware SCBs and initialize them */
>  
> Probably better as kcalloc.

Hey, well spotted! Thanks for your review. I will post a new version soon.

Cheers,

Michael.

>


-- 
Michael Opdenacker, CEO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098
