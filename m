From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 22/41] scsi: lpfc: lpfc_ct: Mark expected switch
 fall-throughs
Date: Thu, 10 Jan 2019 14:03:37 -0600
Message-ID: <3f4cadf2-7251-96e7-0626-4c91fb363b34@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <4e80e3ae7cd0f0c54b45530a3772af4f606b0c8e.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4e80e3ae7cd0f0c54b45530a3772af4f606b0c8e.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping (second one):

Who can ack/review/take this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:31 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/lpfc/lpfc_ct.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> index 6305ffeba7ea..b2b7fcc23654 100644
> --- a/drivers/scsi/lpfc/lpfc_ct.c
> +++ b/drivers/scsi/lpfc/lpfc_ct.c
> @@ -3050,6 +3050,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   	case SLI_MGMT_GHAT:
>   	case SLI_MGMT_GRPL:
>   		rsp_size = FC_MAX_NS_RSP;
> +		/* fall through */
>   	case SLI_MGMT_DHBA:
>   	case SLI_MGMT_DHAT:
>   		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
> @@ -3062,6 +3063,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
>   	case SLI_MGMT_GPAT:
>   	case SLI_MGMT_GPAS:
>   		rsp_size = FC_MAX_NS_RSP;
> +		/* fall through */
>   	case SLI_MGMT_DPRT:
>   	case SLI_MGMT_DPA:
>   		pe = (struct lpfc_fdmi_port_entry *)&CtReq->un.PortID;
> 
