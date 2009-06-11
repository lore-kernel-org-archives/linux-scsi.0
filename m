From: Greg KH <gregkh@suse.de>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
	controller
Date: Wed, 10 Jun 2009 18:23:19 -0700
Message-ID: <20090611012319.GC31460@suse.de>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35557 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbZFKBhf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Jun 2009 21:37:35 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, Jun 10, 2009 at 01:07:12PM -0700, Anil Ravindranath wrote:
> Hi,
> 
> This patch adds a driver to support PMC-Sierra 6Gb/s SAS RAID controller. 
> This patch is created against scsi-misc-2.6.git.

You forgot a "Signed-off-by:" line, that will be necessary for anyone to
be able to accept this patch :(

> +static struct pci_device_id pmcraid_pci_table[] __devinitdata = {
> +	{PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_MAXRAID,
> +	 PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	 (kernel_ulong_t)&pmcraid_chip_cfg[0]
> +	},
> +	{PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_0x8010,
> +	 PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> +	 (kernel_ulong_t)&pmcraid_chip_cfg[0]
> +	},

Minor nit, you can use the PCI_DRIVER() macro here to make it a bit
cleaner.

thanks,

greg k-h
