From: Jinpu Wang <jinpu.wang@profitbricks.com>
Subject: Re: [PATCH 04/29] scsi: pm8001: constify pci_device_id.
Date: Mon, 31 Jul 2017 10:10:20 +0200
Message-ID: <CAMGffEkq7w5C=cWg=FhwoZMO5SAmMtBW7sT_5GVbPpjQhaCegg@mail.gmail.com>
References: <1501403839-8876-1-git-send-email-arvind.yadav.cs@gmail.com> <1501403839-8876-5-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501403839-8876-5-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, mdr@sgi.com, Hannes Reinecke <hare@suse.com>, aacraid@adaptec.com, matthew@wil.cx, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, gotom@debian.or.jp, mrochs@linux.vnet.ibm.com, yokota@netlab.is.tsukuba.ac.jp, QLogic-Storage-Upstream@cavium.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 30, 2017 at 10:37 AM, Arvind Yadav
<arvind.yadav.cs@gmail.com> wrote:
> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> ---
>  drivers/scsi/pm8001/pm8001_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index 034b2f7..f2757cc 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -1270,7 +1270,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
>  /* update of pci device, vendor id and driver data with
>   * unique value for each of the controller
>   */
> -static struct pci_device_id pm8001_pci_table[] = {
> +static const struct pci_device_id pm8001_pci_table[] = {
>         { PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
>         { PCI_VDEVICE(PMC_Sierra, 0x8006), chip_8006 },
>         { PCI_VDEVICE(ADAPTEC2, 0x8006), chip_8006 },
> --
> 2.7.4
>

Thanks,
Acked-by: Jack Wang <jinpu.wang@profitbricks.com>

-- 
Jack Wang
Linux Kernel Developer
