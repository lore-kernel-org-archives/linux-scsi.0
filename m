From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 05/10] drivers/scsi/arcmsr: Fix continuation line
 formats
Date: Mon, 01 Feb 2010 11:16:56 -0600
Message-ID: <1265044616.6910.15.camel@mulgrave.site>
References: <cover.1264967493.git.joe@perches.com>
	 <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1a318fa326c6ab2584b9d318bd1538e7f7debbdf.1264967499.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2010-01-31 at 12:02 -0800, Joe Perches wrote: 
> String constants that are continued on subsequent lines with \
> are not good.

Why?  It's perfectly valid ansi C.

> Fix rebulid/rebuild typos
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/arcmsr/arcmsr_hba.c |   49 +++++++++++++++++--------------------
>  1 files changed, 23 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> index 47d5d19..a0378d5 100644
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c
> @@ -585,8 +585,8 @@ static void arcmsr_flush_hba_cache(struct AdapterControlBlock *acb)
>  			break;
>  		else {
>  			retry_count--;
> -			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' \
> -			timeout, retry count down = %d \n", acb->host->host_no, retry_count);

So I might personally dislike this style

> +			printk(KERN_NOTICE "arcmsr%d: wait 'flush adapter cache' timeout, retry count down = %d \n",
> +			       acb->host->host_no, retry_count);

but I also dislike your solution; I'd have split the string into two
separate ones and relied on compiler concatenation.

However, the point is that all three are perfectly legal C.  Choosing
one form over another is something best left to the maintainers rather
than imposing one style by fiat.

Consider this change veto'd unless you can get an explicit ack from the
current maintainer for changing their style.

James
