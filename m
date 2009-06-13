From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: PATCH: PMC-Sierra MaxRAID driver to support 6Gb/s SAS RAID
 controller
Date: Sat, 13 Jun 2009 00:04:38 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0906130001590.24868@rslab159.pmc-sierra.bc.ca>
References: <alpine.LNX.1.10.0906101259500.24722@rslab159.pmc-sierra.bc.ca> <20090611012319.GC31460@suse.de> <alpine.LNX.1.10.0906102249430.32153@rslab159.pmc-sierra.bc.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:37785 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbZFMHqD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Jun 2009 03:46:03 -0400
In-Reply-To: <alpine.LNX.1.10.0906102249430.32153@rslab159.pmc-sierra.bc.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com



On Wed, 10 Jun 2009, Anil Ravindranath wrote:

> 
> 
> On Wed, 10 Jun 2009, Greg KH wrote:
> 
> > On Wed, Jun 10, 2009 at 01:07:12PM -0700, Anil Ravindranath wrote:
> > > Hi,
> > > 
> > > This patch adds a driver to support PMC-Sierra 6Gb/s SAS RAID controller. 
> > > This patch is created against scsi-misc-2.6.git.
> > 
> > You forgot a "Signed-off-by:" line, that will be necessary for anyone to
> > be able to accept this patch :(
> > 
> Oops. Sorry.
> 
> SIGNED-OFF-BY: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
> 
> > > +static struct pci_device_id pmcraid_pci_table[] __devinitdata = {
> > > +	{PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_MAXRAID,
> > > +	 PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> > > +	 (kernel_ulong_t)&pmcraid_chip_cfg[0]
> > > +	},
> > > +	{PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_0x8010,
> > > +	 PCI_ANY_ID, PCI_ANY_ID, 0, 0,
> > > +	 (kernel_ulong_t)&pmcraid_chip_cfg[0]
> > > +	},
> > 
> > Minor nit, you can use the PCI_DRIVER() macro here to make it a bit
> > cleaner.
> >
> Sure. I will look into this and modify accordingly.
>  

Will change this to PCI_VDEVICE macro instead.

> > thanks,
> > 
> > greg k-h
> > 
> 
