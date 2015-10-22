From: Vaishali Thakkar <vthakkar1994@gmail.com>
Subject: Re: [PATCH] scsi: wd719x: Remove use of macro DEFINE_PCI_DEVICE_TABLE
Date: Thu, 22 Oct 2015 17:02:41 +0530
Message-ID: <CAK-LDbLOn-tN=AVUkSCA=bXXd5aOj0gLSXWDLnV=GQLS7TyB7w@mail.gmail.com>
References: <1445466207-23265-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445466207-23265-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Muhammad Falak R Wani <falakreyaz@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ondrej Zary <linux@rainbow-software.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Oct 22, 2015 at 3:53 AM, Muhammad Falak R Wani
<falakreyaz@gmail.com> wrote:
> Use struct pci_device_id instead of DEFINE_PCI_DEVICE_TABLE with
> the goal of getting rid of this macro completely, as this macro
> is deprecated.

Duplicate of :https://lkml.org/lkml/2015/7/17/62

> Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
> ---
>  drivers/scsi/wd719x.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
> index e3da1a2..2a9da2e 100644
> --- a/drivers/scsi/wd719x.c
> +++ b/drivers/scsi/wd719x.c
> @@ -962,7 +962,7 @@ static void wd719x_pci_remove(struct pci_dev *pdev)
>         scsi_host_put(sh);
>  }
>
> -static DEFINE_PCI_DEVICE_TABLE(wd719x_pci_table) = {
> +static const struct pci_device_id wd719x_pci_table[] = {
>         { PCI_DEVICE(PCI_VENDOR_ID_WD, 0x3296) },
>         {}
>  };
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Vaishali
