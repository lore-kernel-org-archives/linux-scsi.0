From: Nathan Chancellor <natechancellor@gmail.com>
Subject: Re: [PATCH] scsi: nsp32: Remove unnecessary self assignment in
 nsp32_set_sync_entry
Date: Sat, 26 Jan 2019 12:11:43 -0700
Message-ID: <20190126191143.GB25003@archlinux-ryzen>
References: <20181210235156.6237-1-natechancellor@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181210235156.6237-1-natechancellor@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Dec 10, 2018 at 04:51:56PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> drivers/scsi/nsp32.c:2444:14: warning: explicitly assigning value of
> variable of type 'unsigned char' to itself [-Wself-assign]
>         offset      = offset;
>         ~~~~~~      ^
> 
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
> ---
>  drivers/scsi/nsp32.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 5aac3e801903..7ce6e7acf2f3 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -2441,7 +2441,6 @@ static void nsp32_set_sync_entry(nsp32_hw_data *data,
>  
>  	period      = data->synct[entry].period_num;
>  	ackwidth    = data->synct[entry].ackwidth;
> -	offset      = offset;
>  	sample_rate = data->synct[entry].sample_rate;
>  
>  	target->syncreg    = TO_SYNCREG(period, offset);
> -- 
> 2.20.0
> 

Ping?
