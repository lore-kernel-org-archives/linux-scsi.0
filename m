From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 5/6] g_NCR5380: Autoprobe IRQ by default
Date: Sat, 3 Dec 2016 11:39:41 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1612031132060.24005@nippy.intranet>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org> <1477945112-25659-6-git-send-email-linux@rainbow-software.org> <alpine.LNX.2.00.1611011234400.25806@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1611011234400.25806@nippy.intranet>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Ondrej,

On Wed, 2 Nov 2016, I wrote:

> 
> I think this patch is incomplete and you should add these changes:
> 
> diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
> index 7299ad9..0bf0322 100644
> --- a/drivers/scsi/g_NCR5380.c
> +++ b/drivers/scsi/g_NCR5380.c
> @@ -44,7 +44,7 @@ static int ncr_53c400;
>  static int ncr_53c400a;
>  static int dtc_3181e;
>  static int hp_c2502;
> -module_param(ncr_irq, int, 0);
> +module_param(ncr_irq, int, IRQ_AUTO);

Oops, this doesn't even compile! Sorry about that.

What I was trying to achieve was,

-static int ncr_irq;
+static int ncr_irq = IRQ_AUTO;

I will update my patch queue, compile test it, and ask you to review.

-- 
