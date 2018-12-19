From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 08/41] scsi: be2iscsi: be_main: Mark expected switch
 fall-through
Date: Wed, 19 Dec 2018 09:38:27 -0600
Message-ID: <8cecc2e7-5008-678f-e2de-7d8ab3b95195@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <ca994231ba2101ba489ee7b18862a10a8c9dad7e.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <ca994231ba2101ba489ee7b18862a10a8c9dad7e.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Subbu Seetharaman <subbu.seetharaman@broadcom.com>, Ketan Mukadam <ketan.mukadam@broadcom.com>, Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:27 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 1357387 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/be2iscsi/be_main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index effb6fc95af4..b6449da1320c 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -1539,6 +1539,7 @@ beiscsi_hdl_get_handle(struct beiscsi_conn *beiscsi_conn,
>   		break;
>   	case UNSOL_DATA_DIGEST_ERROR_NOTIFY:
>   		error = 1;
> +		/* fall through */
>   	case UNSOL_DATA_NOTIFY:
>   		pasync_handle = pasync_ctx->async_entry[ci].data;
>   		break;
> 
