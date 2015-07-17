From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsi:Fix comment about return values for the function
 ibmvfc_target_alloc
Date: Fri, 17 Jul 2015 14:13:43 -0700
Message-ID: <55A97007.4040605@linux.vnet.ibm.com>
References: <1436472994-31885-1-git-send-email-xerofoify@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436472994-31885-1-git-send-email-xerofoify@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicholas Krause <xerofoify@gmail.com>
Cc: JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/09/2015 01:16 PM, Nicholas Krause wrote:
> This fixes the comment about return values for the function
> ibmvfc_target_alloc to correctly state it only returns zero
> as it always runs successfully and therefore never signals
> its caller with the error code -ENXIO due to this exact
> reasoning.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

Again, just a nit on the patch description wording. Something like the
following would suffice.

"Remove mention of -ENXIO from comment on return values for
ibmvfc_slave_alloc() as the function currently always returns 0."

Otherwise,

Acked-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 057d277..55f161b 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -2854,7 +2854,7 @@ static int ibmvfc_slave_alloc(struct scsi_device *sdev)
>   * expected.
>   *
>   * Returns:
> - *	0 on success / -ENXIO if device does not exist
> + *	0 on success
>   **/
>  static int ibmvfc_target_alloc(struct scsi_target *starget)
>  {
> 
