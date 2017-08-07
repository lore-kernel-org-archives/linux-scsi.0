From: Masanori Goto <gotom@debian.or.jp>
Subject: Re: [PATCH 21/29] scsi: nsp32: constify pci_device_id.
Date: Mon, 7 Aug 2017 10:37:03 +0900
Message-ID: <CALZLnaFDqcigXOt1kYAwpDsVTqn4YX+VDMyFDB6oaXmutkVASg@mail.gmail.com>
References: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1501404235-9105-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Michael Reed <mdr@sgi.com>, hare@suse.com, aacraid@adaptec.com, Matthew Wilcox <matthew@wil.cx>, fthain@telegraphics.com.au, schmitzmic@gmail.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, mrochs@linux.vnet.ibm.com, QLogic-Storage-Upstream@cavium.com, jinpu.wang@profitbricks.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2017-07-30 17:43 GMT+09:00 Arvind Yadav <arvind.yadav.cs@gmail.com>:
>
> pci_device_id are not supposed to change at runtime. All functions
> working with pci_device_id provided by <linux/pci.h> work with
> const pci_device_id. So mark the non-const structs as const.
>
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Thank you!  (resending it twice due to an error)

Acked-by: Masanori Goto <gotom@debian.or.jp>


> ---
>  drivers/scsi/nsp32.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
> index 53c8477..1430b3c 100644
> --- a/drivers/scsi/nsp32.c
> +++ b/drivers/scsi/nsp32.c
> @@ -76,7 +76,7 @@ static const char *nsp32_release_version = "1.2";
>  /****************************************************************************
>   * Supported hardware
>   */
> -static struct pci_device_id nsp32_pci_table[] = {
> +static const struct pci_device_id nsp32_pci_table[] = {
>         {
>                 .vendor      = PCI_VENDOR_ID_IODATA,
>                 .device      = PCI_DEVICE_ID_NINJASCSI_32BI_CBSC_II,
> --
> 2.7.4
