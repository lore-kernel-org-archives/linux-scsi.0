From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/1] scsi: hpsa, add all PCI ID's that HP has in svn
Date: Fri, 17 Jan 2014 16:13:41 +0100
Message-ID: <52D948A5.1070706@redhat.com>
References: <20140116195112.GA9658@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140116195112.GA9658@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>, Andrew Morton <akpm@linux-foundation.org>, "James E. J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKML-scsi <linux-scsi@vger.kernel.org>, hare@suse.de, "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
List-Id: linux-scsi@vger.kernel.org

On 01/16/2014 08:51 PM, Mike Miller wrote:
> From: Mike Miller <mike.miller@hp.com>
>
> This patch has every ID we have in our svn repository. Some controllers were
> cancelled, others added, now the cancelled ones are back. Apparently the
> debate rages on about which controllers are cancelled, which are not,
> whatever. Please accept this patch. It is dependent upon the patches I sent
> yesterday. 
> This patch made/tested against kernel-3.13.0-rc8
>
> Signed-off-by: Mike Miller <mike.miller@hp.com>
> ---
>  drivers/scsi/hpsa.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 348b207..3affec5 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -100,6 +100,7 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1920},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
> @@ -108,15 +109,19 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x192A},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BD},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BE},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21BF},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C0},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C2},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C3},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C4},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C5},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C6},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C7},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C8},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21C9},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CA},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CB},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSI,     0x103C, 0x21CC},
> @@ -149,22 +154,29 @@ static struct board_type products[] = {
>  	{0x3354103C, "Smart Array P420i", &SA5_access},
>  	{0x3355103C, "Smart Array P220i", &SA5_access},
>  	{0x3356103C, "Smart Array P721m", &SA5_access},
> +	{0x1920103C, "Smart Array P430i", &SA5_access},
>  	{0x1921103C, "Smart Array P830i", &SA5_access},
>  	{0x1922103C, "Smart Array P430", &SA5_access},
>  	{0x1923103C, "Smart Array P431", &SA5_access},
>  	{0x1924103C, "Smart Array P830", &SA5_access},
> +	{0x1925103C, "Smart Array P831", &SA5_access},
>  	{0x1926103C, "Smart Array P731m", &SA5_access},
>  	{0x1928103C, "Smart Array P230i", &SA5_access},
>  	{0x1929103C, "Smart Array P530", &SA5_access},
> +	{0x192A103C, "Smart Array P531", &SA5_access},
>  	{0x21BD103C, "Smart Array", &SA5_access},
>  	{0x21BE103C, "Smart Array", &SA5_access},
>  	{0x21BF103C, "Smart Array", &SA5_access},
>  	{0x21C0103C, "Smart Array", &SA5_access},
> +	{0x21C1103C, "Smart Array", &SA5_access},

I think that both tables should be in sync - but there is no 0x21c1 in hpsa_pci_device_id
(and the 0x1925), could you clarify that?

Thanks, Tomas 

>  	{0x21C2103C, "Smart Array", &SA5_access},
>  	{0x21C3103C, "Smart Array", &SA5_access},
> +	{0x21C4103C, "Smart Array", &SA5_access},
>  	{0x21C5103C, "Smart Array", &SA5_access},
> +	{0x21C6103C, "Smart Array", &SA5_access},
>  	{0x21C7103C, "Smart Array", &SA5_access},
>  	{0x21C8103C, "Smart Array", &SA5_access},
> +	{0x21C9103C, "Smart Array", &SA5_access},
>  	{0x21CA103C, "Smart Array", &SA5_access},
>  	{0x21CB103C, "Smart Array", &SA5_access},
>  	{0x21CC103C, "Smart Array", &SA5_access},
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
