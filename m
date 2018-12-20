From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 32/41] scsi: myrb: Mark expected switch fall-throughs
Date: Wed, 19 Dec 2018 18:07:15 -0600
Message-ID: <025dd9a3-e2a0-cb21-8458-f671a673f634@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <15cf75b544d6b2eae77ba98cd201620b44abec36.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <15cf75b544d6b2eae77ba98cd201620b44abec36.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:32 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 1465234 ("Missing break in switch")
> Addresses-Coverity-ID: 1465238 ("Missing break in switch")
> Addresses-Coverity-ID: 1465242 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/myrb.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
> index 0642f2d0a3bb..539ac8ce4fcd 100644
> --- a/drivers/scsi/myrb.c
> +++ b/drivers/scsi/myrb.c
> @@ -1528,6 +1528,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
>   			scmd->scsi_done(scmd);
>   			return 0;
>   		}
> +		/* fall through */
>   	case WRITE_6:
>   		lba = (((scmd->cmnd[1] & 0x1F) << 16) |
>   		       (scmd->cmnd[2] << 8) |
> @@ -1544,6 +1545,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
>   			scmd->scsi_done(scmd);
>   			return 0;
>   		}
> +		/* fall through */
>   	case WRITE_10:
>   	case VERIFY:		/* 0x2F */
>   	case WRITE_VERIFY:	/* 0x2E */
> @@ -1560,6 +1562,7 @@ static int myrb_ldev_queuecommand(struct Scsi_Host *shost,
>   			scmd->scsi_done(scmd);
>   			return 0;
>   		}
> +		/* fall through */
>   	case WRITE_12:
>   	case VERIFY_12: /* 0xAF */
>   	case WRITE_VERIFY_12:	/* 0xAE */
> 
