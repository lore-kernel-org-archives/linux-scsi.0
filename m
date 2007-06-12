From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Date: Tue, 12 Jun 2007 16:58:24 +0100
Message-ID: <20070612155824.GB14044@srcf.ucam.org>
References: <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net> <20070612153828.GA13888@srcf.ucam.org> <466EBFF0.70100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <466EBFF0.70100@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Arjan van de Ven <arjan@linux.intel.com>, Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 12, 2007 at 11:46:56AM -0400, Jeff Garzik wrote:
> Matthew Garrett wrote:
> >On Tue, Jun 12, 2007 at 11:17:14AM -0300, Henrique de Moraes Holschuh 
> >wrote:
> >>On Tue, 12 Jun 2007, Matthew Garrett wrote:
> >>>Laptop bays are designed to deal with hotplugging PATA - I don't think 
> >>>this is too much of an issue :)
> >>The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
> >>cards use usb2.0 and pci-e hotplug...
> >
> >Yes, but they'll also send an ACPI interrupt even if the SATA host 
> >controller doesn't - it's part of the spec for bays.
> 
> Regardless, having a laptop does not imply having a docking bay.

Excluding the corner case of an Expresscard SATA controller (where I 
suspect you'd want different policy), I doubt there are any cases where 
you have a laptop with hotplug capabilities without it being implemented 
as an ACPI bay.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
