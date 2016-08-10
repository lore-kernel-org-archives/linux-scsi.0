From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH V4 2/2] aacraid: remove wildcard for series 9
 controllers
Date: Wed, 10 Aug 2016 12:14:34 -0400
Message-ID: <1470845674.12971.21.camel@localhost.localdomain>
References: <146706289746.29152.13840476577189238722.stgit@brunhilda>
	 <146706367078.29152.14405582249219794335.stgit@brunhilda>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933565AbcHJSnH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Aug 2016 14:43:07 -0400
In-Reply-To: <146706367078.29152.14405582249219794335.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com, linux-scsi@vger.kernel.org

On Mon, 2016-06-27 at 16:41 -0500, Don Brace wrote:
> Depends on smartpqi driver adoption
> 
> Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>
> ---
>  drivers/scsi/aacraid/linit.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 79871f3..d5b26fa 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -160,7 +160,6 @@ static const struct pci_device_id aac_pci_tbl[] = {
>  	{ 0x9005, 0x028b, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 62 }, /* Adaptec PMC Series 6 (Tupelo) */
>  	{ 0x9005, 0x028c, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 63 }, /* Adaptec PMC Series 7 (Denali) */
>  	{ 0x9005, 0x028d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 64 }, /* Adaptec PMC Series 8 */
> -	{ 0x9005, 0x028f, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 65 }, /* Adaptec PMC Series 9 */
>  	{ 0,}
>  };
>  MODULE_DEVICE_TABLE(pci, aac_pci_tbl);
> @@ -239,7 +238,6 @@ static struct aac_driver_ident aac_drivers[] = {
>  	{ aac_src_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 6 (Tupelo) */
>  	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 7 (Denali) */
>  	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC }, /* Adaptec PMC Series 8 */
> -	{ aac_srcv_init, "aacraid", "ADAPTEC ", "RAID            ", 2, AAC_QUIRK_SRC } /* Adaptec PMC Series 9 */
>  };
>  
>  /**
> 

Depends upon smartpqi incorporation for support of these removed IDs.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


