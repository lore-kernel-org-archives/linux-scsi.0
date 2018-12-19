From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 13/41] scsi: csiostor: csio_wr: mark expected switch
 fall-through
Date: Wed, 19 Dec 2018 09:39:42 -0600
Message-ID: <a05a7975-b09b-fd0a-8af1-82ab3b90596e@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <5e846a635bfaf121af56e1f60a99816091e55170.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5e846a635bfaf121af56e1f60a99816091e55170.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:28 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 1056538 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/csiostor/csio_wr.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/csiostor/csio_wr.c b/drivers/scsi/csiostor/csio_wr.c
> index dc12933533d5..b6861ea66c9f 100644
> --- a/drivers/scsi/csiostor/csio_wr.c
> +++ b/drivers/scsi/csiostor/csio_wr.c
> @@ -808,6 +808,7 @@ csio_wr_destroy_queues(struct csio_hw *hw, bool cmd)
>   
>   				csio_q_eqid(hw, i) = CSIO_MAX_QID;
>   			}
> +			/* fall through */
>   		case CSIO_INGRESS:
>   			if (csio_q_iqid(hw, i) != CSIO_MAX_QID) {
>   				csio_wr_cleanup_iq_ftr(hw, i);
> 
