From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] drivers: scsi: #define missing include guards
Date: Tue, 26 Aug 2014 11:26:55 +0200
Message-ID: <53FC52DF.2000007@suse.de>
References: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1408711053-14129-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/22/2014 02:37 PM, Rasmus Villemoes wrote:
> The four files aha1542.h, aha1740.h, gvp11.h and mvme147.h under
> drivers/scsi/ contain two-thirds of an include guard, but do not
> elsewhere.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>   drivers/scsi/aha1542.h | 1 +
>   drivers/scsi/aha1740.h | 1 +
>   drivers/scsi/gvp11.h   | 1 +
>   drivers/scsi/mvme147.h | 1 +
>   4 files changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/aha1542.h b/drivers/scsi/aha1542.h
> index b871d2b..8f4e07a 100644
> --- a/drivers/scsi/aha1542.h
> +++ b/drivers/scsi/aha1542.h
> @@ -1,4 +1,5 @@
>   #ifndef _AHA1542_H
> +#define _AHA1542_H
>
>   /* $Id: aha1542.h,v 1.1 1992/07/24 06:27:38 root Exp root $
>    *
> diff --git a/drivers/scsi/aha1740.h b/drivers/scsi/aha1740.h
> index af23fd6..7ea484f 100644
> --- a/drivers/scsi/aha1740.h
> +++ b/drivers/scsi/aha1740.h
> @@ -1,4 +1,5 @@
>   #ifndef _AHA1740_H
> +#define _AHA1740_H
>
>   /* $Id$
>    *
> diff --git a/drivers/scsi/gvp11.h b/drivers/scsi/gvp11.h
> index 852913c..5aabe90 100644
> --- a/drivers/scsi/gvp11.h
> +++ b/drivers/scsi/gvp11.h
> @@ -1,4 +1,5 @@
>   #ifndef GVP11_H
> +#define GVP11_H
>
>   /* $Id: gvp11.h,v 1.4 1997/01/19 23:07:12 davem Exp $
>    *
> diff --git a/drivers/scsi/mvme147.h b/drivers/scsi/mvme147.h
> index bfd4566..479e9b4 100644
> --- a/drivers/scsi/mvme147.h
> +++ b/drivers/scsi/mvme147.h
> @@ -1,4 +1,5 @@
>   #ifndef MVME147_H
> +#define MVME147_H
>
>   /* $Id: mvme147.h,v 1.4 1997/01/19 23:07:10 davem Exp $
>    *
>
Not that it matter much, but:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
