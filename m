From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 02/11] hpsa: correct decode sense data
Date: Wed, 22 Jul 2015 17:16:30 +0200
Message-ID: <55AFB3CE.3080501@redhat.com>
References: <20150718160245.31955.16794.stgit@brunhilda>
 <20150718161228.31955.89625.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933634AbbGVPQd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 11:16:33 -0400
In-Reply-To: <20150718161228.31955.89625.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

On 18.7.2015 18:12, Don Brace wrote:
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

> ---
>  drivers/scsi/hpsa.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 1d5f4fd..e9b2073 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -325,7 +325,7 @@ static int check_for_unit_attention(struct ctlr_info *h,
>  
>  	decode_sense_data(c->err_info->SenseInfo, sense_len,
>  				&sense_key, &asc, &ascq);
> -	if (sense_key != UNIT_ATTENTION || asc == -1)
> +	if (sense_key != UNIT_ATTENTION || asc == 0xff)
>  		return 0;
>  
>  	switch (asc) {
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

