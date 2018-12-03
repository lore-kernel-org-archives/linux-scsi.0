From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 01/41] scsi: BusLogic: mark expected switch fall-through
Date: Mon, 3 Dec 2018 11:33:23 -0700
Message-ID: <0d5df4a3-c614-572b-45e6-bd29f13ed361@gonehiking.org>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <de0c68b4f655080a7336d1ad256d77a83ab0b7d6.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <de0c68b4f655080a7336d1ad256d77a83ab0b7d6.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 11/27/18 9:21 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 1056537 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/scsi/BusLogic.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 9cee941f97d6..717eef3ee893 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2641,6 +2641,7 @@ static int blogic_resultcode(struct blogic_adapter *adapter,
>  	case BLOGIC_BAD_CMD_PARAM:
>  		blogic_warn("BusLogic Driver Protocol Error 0x%02X\n",
>  				adapter, adapter_status);
> +		/* fall through */
>  	case BLOGIC_DATA_UNDERRUN:
>  	case BLOGIC_DATA_OVERRUN:
>  	case BLOGIC_NOEXPECT_BUSFREE:
> 

Looks good.

Acked-by: Khalid Aziz <khalid@gonehiking.org>
