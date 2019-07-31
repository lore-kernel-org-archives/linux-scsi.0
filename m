From: Tyrel Datwyler <tyreld@linux.ibm.com>
Subject: Re: [PATCH] scsi: ibmvfc: Mark expected switch fall-throughs
Date: Tue, 30 Jul 2019 18:41:53 -0700
Message-ID: <58a4f287-8311-31ee-f403-16b0adcf0271@linux.ibm.com>
References: <20190729002608.GA25263@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190729002608.GA25263@embeddedor>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

On 7/28/19 5:26 PM, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings:
> 
> drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_npiv_login_done':
> drivers/scsi/ibmvscsi/ibmvfc.c:4022:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    ibmvfc_retry_host_init(vhost);
>    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ibmvscsi/ibmvfc.c:4023:2: note: here
>   case IBMVFC_MAD_DRIVER_FAILED:
>   ^~~~
> drivers/scsi/ibmvscsi/ibmvfc.c: In function 'ibmvfc_bsg_request':
> drivers/scsi/ibmvscsi/ibmvfc.c:1830:11: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    port_id = (bsg_request->rqst_data.h_els.port_id[0] << 16) |
>    ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     (bsg_request->rqst_data.h_els.port_id[1] << 8) |
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     bsg_request->rqst_data.h_els.port_id[2];
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ibmvscsi/ibmvfc.c:1833:2: note: here
>   case FC_BSG_RPT_ELS:
>   ^~~~
> drivers/scsi/ibmvscsi/ibmvfc.c:1838:11: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    port_id = (bsg_request->rqst_data.h_ct.port_id[0] << 16) |
>    ~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     (bsg_request->rqst_data.h_ct.port_id[1] << 8) |
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     bsg_request->rqst_data.h_ct.port_id[2];
>     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/scsi/ibmvscsi/ibmvfc.c:1841:2: note: here
>   case FC_BSG_RPT_CT:
>   ^~~~
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---

Acked-by: Tyrel Datwyler <tyreld@linux.ibm.com>
