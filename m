From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/2] hpsa: update pci ids
Date: Wed, 29 Mar 2017 17:43:46 +0200
Message-ID: <f997a22e-7b62-0850-03d3-352e055d4b65@redhat.com>
References: <149073716991.23669.3063211911971326983.stgit@brunhilda>
 <149073721384.23669.10598426212290266393.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752642AbdC2Pnw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Mar 2017 11:43:52 -0400
In-Reply-To: <149073721384.23669.10598426212290266393.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

On 28.3.2017 23:40, Don Brace wrote:
> Reviewed-by: Gerry Morong <gerry.morong@microsemi.com>
> Reviewed-by: Scott Teel <scott.teel@microsemi.com>
> Signed-off-by: Don Brace <don.brace@microsemi.com>

Hi Don

has a gen9 device with id=0x334D ever been released?
https://lkml.org/lkml/2013/9/4/499
seems to be still missing in the current table.

tomash

> ---
>  drivers/scsi/hpsa.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index 0d0be77..668cf47 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -108,10 +108,12 @@ static const struct pci_device_id hpsa_pci_device_id[] = {
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3354},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3355},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSF,     0x103C, 0x3356},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103c, 0x1920},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1921},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1922},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1923},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1924},
> +	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103c, 0x1925},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1926},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1928},
>  	{PCI_VENDOR_ID_HP,     PCI_DEVICE_ID_HP_CISSH,     0x103C, 0x1929},
> @@ -171,10 +173,12 @@ static struct board_type products[] = {
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
>
