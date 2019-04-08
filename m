From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] scsi/NCR5380: Avoid compiler warning when
 -Wimplicit-fallthrough is enabled
Date: Mon, 8 Apr 2019 18:44:47 -0500
Message-ID: <fd71e91a-92e4-9e96-7d5a-4d9a58f7128f@embeddedor.com>
References: <4e853f171366e040818346def7fb043347670662.1551995342.git.fthain@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4e853f171366e040818346def7fb043347670662.1551995342.git.fthain@telegraphics.com.au>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

Friendly ping:

Who can take this?

Thanks

On 3/7/19 3:49 PM, Finn Thain wrote:
> Adjust comments accordingly.
> 
> Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
> ---
>  drivers/scsi/NCR5380.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
> index 7fed9bb72784..fe0535affc14 100644
> --- a/drivers/scsi/NCR5380.c
> +++ b/drivers/scsi/NCR5380.c
> @@ -1932,13 +1932,13 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
>  					if (!hostdata->connected)
>  						return;
>  
> -					/* Fall through to reject message */
> -
> +					/* Reject message */
> +					/* Fall through */
> +				default:
>  					/*
>  					 * If we get something weird that we aren't expecting,
> -					 * reject it.
> +					 * log it.
>  					 */
> -				default:
>  					if (tmp == EXTENDED_MESSAGE)
>  						scmd_printk(KERN_INFO, cmd,
>  						            "rejecting unknown extended message code %02x, length %d\n",
> 
