From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 38/41] scsi: sym53c8xx_2: sym_hipd: mark expected switch
 fall-throughs
Date: Wed, 19 Dec 2018 18:08:18 -0600
Message-ID: <7ecbfc9c-4c03-c441-cf9b-c5a44d5a9ea5@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <81f959a632339d224fd0dd894746d1081bf249f3.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <81f959a632339d224fd0dd894746d1081bf249f3.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@infradead.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
--
Gustavo

On 11/27/18 10:34 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Addresses-Coverity-ID: 114996 ("Missing break in switch")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/sym53c8xx_2/sym_hipd.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/sym53c8xx_2/sym_hipd.c b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> index 0a2a54517b15..054fb0599263 100644
> --- a/drivers/scsi/sym53c8xx_2/sym_hipd.c
> +++ b/drivers/scsi/sym53c8xx_2/sym_hipd.c
> @@ -3072,6 +3072,7 @@ static void sym_sir_bad_scsi_status(struct sym_hcb *np, int num, struct sym_ccb
>   			sym_print_addr(cp->cmd, "%s\n",
>   			        s_status == S_BUSY ? "BUSY" : "QUEUE FULL\n");
>   		}
> +		/* fall through */
>   	default:	/* S_INT, S_INT_COND_MET, S_CONFLICT */
>   		sym_complete_error (np, cp);
>   		break;
> @@ -4632,6 +4633,7 @@ static void sym_int_sir(struct sym_hcb *np)
>   	 *  Negotiation failed.
>   	 *  Target does not want answer message.
>   	 */
> +	/* fall through */
>   	case SIR_NEGO_PROTO:
>   		sym_nego_default(np, tp, cp);
>   		goto out;
> 
