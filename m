From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/6] mpt fusion: Add support for ATTO 4LD: Rebranded LSI 53C1030
Date: Tue, 14 Aug 2007 12:47:38 -0600
Message-ID: <20070814184738.GR16277@parisc-linux.org>
References: <20070814103330.GA9944@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:47466 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761450AbXHNSrj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Aug 2007 14:47:39 -0400
Content-Disposition: inline
In-Reply-To: <20070814103330.GA9944@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <sathya.prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org, eric.moore@lsi.com

On Tue, Aug 14, 2007 at 04:03:31PM +0530, Prakash, Sathya wrote:
> +++ b/drivers/message/fusion/mptspi.c
> @@ -1190,6 +1190,8 @@ static struct spi_function_template mptspi_transport_functions = {
>  static struct pci_device_id mptspi_pci_table[] = {
>  	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1030,
>  		PCI_ANY_ID, PCI_ANY_ID },
> +	{ 0x117c /* ATTO */, MPI_MANUFACTPAGE_DEVID_53C1030,
> +		PCI_ANY_ID, PCI_ANY_ID },
>  	{ PCI_VENDOR_ID_LSI_LOGIC, MPI_MANUFACTPAGE_DEVID_53C1035,
>  		PCI_ANY_ID, PCI_ANY_ID },
>  	{0}	/* Terminating entry */

I'd rather see this patch add PCI_VENDOR_ID_ATTO to
include/linux/pci_ids.h

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
