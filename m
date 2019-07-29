From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: wd33c93: Mark expected swich fall-through
Date: Mon, 29 Jul 2019 14:48:54 -0700
Message-ID: <201907291448.C98BB1E8F1@keescook>
References: <20190729210313.GA5896@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190729210313.GA5896@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jul 29, 2019 at 04:03:13PM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warning (Building: m68k):
> 
> drivers/scsi/wd33c93.c: In function ‘round_4’:
> drivers/scsi/wd33c93.c:1856:11: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    case 2: ++x;
>            ^~~
> drivers/scsi/wd33c93.c:1857:3: note: here
>    case 3: ++x;
>    ^~~~
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/scsi/wd33c93.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/wd33c93.c b/drivers/scsi/wd33c93.c
> index fb7b289fa09f..f81046f0e68a 100644
> --- a/drivers/scsi/wd33c93.c
> +++ b/drivers/scsi/wd33c93.c
> @@ -1854,6 +1854,7 @@ round_4(unsigned int x)
>  		case 1: --x;
>  			break;
>  		case 2: ++x;
> +			/* fall through */
>  		case 3: ++x;
>  	}
>  	return x;
> -- 
> 2.22.0
> 

-- 
Kees Cook
