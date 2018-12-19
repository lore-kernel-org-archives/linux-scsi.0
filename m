From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 20/41] scsi: isci: request: mark expected switch
 fall-through
Date: Wed, 19 Dec 2018 16:27:06 -0600
Message-ID: <f70b101e-2c97-b297-5247-fa8acddf8baf@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <544d1da2adb45f369f002638760d1c933b482cb0.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <544d1da2adb45f369f002638760d1c933b482cb0.1543374820.git.gustavo@embeddedor.com>
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

On 11/27/18 10:30 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, a dash is added as a token in
> order to separate the "Fall through" annotation from the rest of the
> comment on the same line, which is what GCC is expecting to find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/isci/request.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
> index 2f151708b59a..1b18cf55167e 100644
> --- a/drivers/scsi/isci/request.c
> +++ b/drivers/scsi/isci/request.c
> @@ -894,7 +894,7 @@ sci_io_request_terminate(struct isci_request *ireq)
>   		 * and don't wait for the task response.
>   		 */
>   		sci_change_state(&ireq->sm, SCI_REQ_ABORTING);
> -		/* Fall through and handle like ABORTING... */
> +		/* Fall through - and handle like ABORTING... */
>   	case SCI_REQ_ABORTING:
>   		if (!isci_remote_device_is_safe_to_abort(ireq->target_device))
>   			set_bit(IREQ_PENDING_ABORT, &ireq->flags);
> 
