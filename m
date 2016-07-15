From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 18/21] lpfc: Correct issue with ioremap() call on 32bit
 kernel
Date: Fri, 15 Jul 2016 15:22:57 +0200
Message-ID: <62af4d63-7e7d-56a4-a1ba-2a964adc5c83@suse.de>
References: <577d5dab.uTZuS8TRN82d5m1T%james.smart@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbcGONW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jul 2016 09:22:59 -0400
In-Reply-To: <577d5dab.uTZuS8TRN82d5m1T%james.smart@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

On 07/06/2016 09:36 PM, James Smart wrote:
>=20
> Correct issue with ioremap() call on 32bit kernel
>=20
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>
> ---
>  drivers/scsi/lpfc/lpfc.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
> index 4d9f1b1..b484859 100644
> --- a/drivers/scsi/lpfc/lpfc.h
> +++ b/drivers/scsi/lpfc/lpfc.h
> @@ -785,9 +785,9 @@ struct lpfc_hba {
> =20
>  	atomic_t fcp_qidx;		/* next work queue to post work to */
> =20
> -	unsigned long pci_bar0_map;     /* Physical address for PCI BAR0 */
> -	unsigned long pci_bar1_map;     /* Physical address for PCI BAR1 */
> -	unsigned long pci_bar2_map;     /* Physical address for PCI BAR2 */
> +	phys_addr_t pci_bar0_map;     /* Physical address for PCI BAR0 */
> +	phys_addr_t pci_bar1_map;     /* Physical address for PCI BAR1 */
> +	phys_addr_t pci_bar2_map;     /* Physical address for PCI BAR2 */
>  	void __iomem *slim_memmap_p;	/* Kernel memory mapped address for
>  					   PCI BAR0 */
>  	void __iomem *ctrl_regs_memmap_p;/* Kernel memory mapped address fo=
r
>=20
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
