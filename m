From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 17/41] scsi: isci: phy: Mark expected switch fall-through
Date: Wed, 19 Dec 2018 16:26:26 -0600
Message-ID: <cf2645c4-c192-a7b1-cf6e-9276f6b3b6c9@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <c07224fd421852f2cb717e6a3e6180eacb5ba372.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c07224fd421852f2cb717e6a3e6180eacb5ba372.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Intel SCU Linux support <intel-linux-scu@intel.com>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
-- 
Gustavo

On 11/27/18 10:29 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 703127 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/isci/phy.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/isci/phy.c b/drivers/scsi/isci/phy.c
> index 1deca8c5a94f..7f9b3f20e5e4 100644
> --- a/drivers/scsi/isci/phy.c
> +++ b/drivers/scsi/isci/phy.c
> @@ -778,6 +778,7 @@ enum sci_status sci_phy_event_handler(struct isci_phy *iphy, u32 event_code)
>   			break;
>   		case SCU_EVENT_LINK_FAILURE:
>   			scu_link_layer_set_txcomsas_timeout(iphy, SCU_SAS_LINK_LAYER_TXCOMSAS_NEGTIME_DEFAULT);
> +			/* fall through */
>   		case SCU_EVENT_HARD_RESET_RECEIVED:
>   			/* Start the oob/sn state machine over again */
>   			sci_change_state(&iphy->sm, SCI_PHY_STARTING);
> 
