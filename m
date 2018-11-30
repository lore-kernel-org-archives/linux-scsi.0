From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH RFC 11/15] scsi: replace **** with a hug
Date: Fri, 30 Nov 2018 12:21:07 -0800
Message-ID: <1543609267.3031.14.camel@linux.vnet.ibm.com>
References: <20181130192737.15053-1-jarkko.sakkinen@linux.intel.com>
         <20181130192737.15053-12-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130192737.15053-12-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2018-11-30 at 11:27 -0800, Jarkko Sakkinen wrote:
> In order to comply with the CoC, replace **** with a hug.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/scsi/qlogicpti.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qlogicpti.h b/drivers/scsi/qlogicpti.h
> index 884ad72ade57..f1785154061c 100644
> --- a/drivers/scsi/qlogicpti.h
> +++ b/drivers/scsi/qlogicpti.h
> @@ -62,7 +62,7 @@
>  #define REQUEST_QUEUE_WAKEUP		0x8005
>  #define EXECUTION_TIMEOUT_RESET		0x8006
>  
> -/* Am I fucking pedantic or what? */
> +/* Am I hugging pedantic or what? */

I really don't think this is either necessary or a good idea.  The code
of conduct explicitly doesn't require this.  It says:

   Contributions submitted for the kernel should use appropriate
   language.
   Content that already exists predating the Code of Conduct will not
   be
   addressed now as a violation.

However, I assume you're thinking about the next sentence:

   Inappropriate language can be seen as a bug, though; such bugs will
   be fixed more quickly if any interested parties submit patches to
   that effect.

?

I would interpret the above comment as simply an expression of
frustration directed by the author at some of the endian problems
drivers like this bring.  Since it's not directed at anything other
than hardware I don't think it could be seen as threatening or abusive
or contributing to a negative environment even if submitted today.

For better or for worse, the word "fuck", which was once seen as so
beyond the pale that only loose tongued individuals like monty python
could get away with it (The great John Cleese use of the word fuck at a
funeral [Eric Chapman's] springing immediately to mind), has now moved
into the TV primetime mainstream and it's not our job to try and
reimpose language decency on the world.

James
