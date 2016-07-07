From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 2/2] libata-scsi: do not return t10 designator if drive
 has WWN
Date: Thu, 7 Jul 2016 13:51:31 +0300
Message-ID: <ca90988b-2c3d-44e2-f993-640e472da403@cogentembedded.com>
References: <20160706221213.1928-1-me>
 <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
Sender: linux-ide-owner@vger.kernel.org
To: tom.ty89@gmail.com, tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hello.

On 7/7/2016 1:12 AM, tom.ty89@gmail.com wrote:

> From: Tom Yan <tom.ty89@gmail.com>
>
> SAT (as of sat4r05f.pdf) only requires the t10 designator if the
> drive does not support/have WWN. Besides, we already have the ATA
> information VPD.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 9f478ad..84b3d42 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[...]
> @@ -2236,6 +2221,23 @@ static unsigned int ata_scsiop_inq_83(struct ata_scsi_args *args, u8 *rbuf)
>  			      ATA_ID_WWN, ATA_ID_WWN_LEN);
>  		num += ATA_ID_WWN_LEN;
>  	}
> +	else {

    CodingStyle, should be:

	} else {

[...]

MBR, Sergei

