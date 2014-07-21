From: Khalid Aziz <khalid@gonehiking.org>
Subject: Re: [PATCH 2/25] BusLogic: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Mon, 21 Jul 2014 08:48:37 -0600
Message-ID: <1405954117.6962.37.camel@rhapsody>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
	 <1405697232-11785-3-git-send-email-benoit.taine@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1405697232-11785-3-git-send-email-benoit.taine@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-07-18 at 17:26 +0200, Benoit Taine wrote:
> We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
> kernel coding style guidelines. This issue was reported by checkpatch.
> 
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> 
> ---
> Tested by compilation without errors.
> 
>  drivers/scsi/BusLogic.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index 972f817..64c7514 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -3893,7 +3893,7 @@ __setup("BusLogic=", blogic_setup);
>  	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
>  	{ }
>  };*/
> -static DEFINE_PCI_DEVICE_TABLE(blogic_pci_tbl) = {
> +static const struct pci_device_id blogic_pci_tbl[] = {
>  	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER)},
>  	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC)},
>  	{PCI_DEVICE(PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_FLASHPOINT)},
> 

Acked-by: Khalid Aziz <khalid@gonehiking.org>
