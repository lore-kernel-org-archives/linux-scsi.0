From: Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH trivial] [SCSI] aic7xxx: Spelling
 s/configuraion/configuration/
Date: Fri, 7 Jun 2019 14:25:40 +0200
Message-ID: <032a117c-3698-a803-a340-6df720d61795@suse.com>
References: <20190607112736.14004-1-geert+renesas@glider.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190607112736.14004-1-geert+renesas@glider.be>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Geert Uytterhoeven <geert+renesas@glider.be>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Jiri Kosina <trivial@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 6/7/19 1:27 PM, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/scsi/aic7xxx/aic7xxx.reg | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx.reg b/drivers/scsi/aic7xxx/aic7xxx.reg
> index ba0b411d03e2e1fa..00fde2243e486cbd 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx.reg
> +++ b/drivers/scsi/aic7xxx/aic7xxx.reg
> @@ -1666,7 +1666,7 @@ scratch_ram {
>  	size		6
>  	/*
>  	 * These are reserved registers in the card's scratch ram on the 2742.
> -	 * The EISA configuraiton chip is mapped here.  On Rev E. of the
> +	 * The EISA configuration chip is mapped here.  On Rev E. of the
>  	 * aic7770, the sequencer can use this area for scratch, but the
>  	 * host cannot directly access these registers.  On later chips, this
>  	 * area can be read and written by both the host and the sequencer.
> 
Indeed trivial.

Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
