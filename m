From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI controllers.
Date: Tue, 12 Jun 2007 16:38:28 +0100
Message-ID: <20070612153828.GA13888@srcf.ucam.org>
References: <20070612011148.GA9808@khazad-dum.debian.net> <466DF3E9.30303@linux.intel.com> <d8jr6oikkcz.fsf@nygaard.ping.uio.no> <466DFE09.3020408@garzik.org> <20070612035928.GB9808@khazad-dum.debian.net> <466E1A32.90306@linux.intel.com> <20070612090940.GA9719@srcf.ucam.org> <20070612121819.GA20408@khazad-dum.debian.net> <20070612135010.GA12601@srcf.ucam.org> <20070612141714.GB20408@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070612141714.GB20408@khazad-dum.debian.net>
Sender: linux-ide-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Arjan van de Ven <arjan@linux.intel.com>, Jeff Garzik <jeff@garzik.org>, Dagfinn Ilmari =?iso-8859-1?Q?Manns=E5ker?= <ilmari@ilmari.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jun 12, 2007 at 11:17:14AM -0300, Henrique de Moraes Holschuh wrote:
> On Tue, 12 Jun 2007, Matthew Garrett wrote:
> > Laptop bays are designed to deal with hotplugging PATA - I don't think 
> > this is too much of an issue :)
> 
> The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
> cards use usb2.0 and pci-e hotplug...

Yes, but they'll also send an ACPI interrupt even if the SATA host 
controller doesn't - it's part of the spec for bays.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
