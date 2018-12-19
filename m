From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 10/41] scsi: bfa: bfa_fcs_lport: Mark expected switch
 fall-throughs
Date: Wed, 19 Dec 2018 09:39:08 -0600
Message-ID: <a2a4fd41-d231-4d72-a95e-e1109c209f94@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <5cc329185c0b92f3aad001fc1afa54996a2c1112.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5cc329185c0b92f3aad001fc1afa54996a2c1112.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
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
> Notice that, in this particular case, I replaced "!!! fall through !!!"
> with a "fall through" annotation, which is what GCC is expecting to
> find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/bfa/bfa_fcs_lport.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
> index b4f2c1d8742e..646f09f66443 100644
> --- a/drivers/scsi/bfa/bfa_fcs_lport.c
> +++ b/drivers/scsi/bfa/bfa_fcs_lport.c
> @@ -6430,9 +6430,7 @@ bfa_fcs_vport_sm_logo_for_stop(struct bfa_fcs_vport_s *vport,
>   	switch (event) {
>   	case BFA_FCS_VPORT_SM_OFFLINE:
>   		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
> -		/*
> -		 * !!! fall through !!!
> -		 */
> +		/* fall through */
>   
>   	case BFA_FCS_VPORT_SM_RSP_OK:
>   	case BFA_FCS_VPORT_SM_RSP_ERROR:
> @@ -6458,9 +6456,7 @@ bfa_fcs_vport_sm_logo(struct bfa_fcs_vport_s *vport,
>   	switch (event) {
>   	case BFA_FCS_VPORT_SM_OFFLINE:
>   		bfa_sm_send_event(vport->lps, BFA_LPS_SM_OFFLINE);
> -		/*
> -		 * !!! fall through !!!
> -		 */
> +		/* fall through */
>   
>   	case BFA_FCS_VPORT_SM_RSP_OK:
>   	case BFA_FCS_VPORT_SM_RSP_ERROR:
> 
