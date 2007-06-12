From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
 controllers.
Date: Tue, 12 Jun 2007 09:27:49 -0700
Message-ID: <20070612092749.ff46bc32.kristen.c.accardi@intel.com>
References: <20070612011148.GA9808@khazad-dum.debian.net>
	<466DF3E9.30303@linux.intel.com>
	<d8jr6oikkcz.fsf@nygaard.ping.uio.no>
	<466DFE09.3020408@garzik.org>
	<20070612035928.GB9808@khazad-dum.debian.net>
	<466E1A32.90306@linux.intel.com>
	<20070612090940.GA9719@srcf.ucam.org>
	<20070612121819.GA20408@khazad-dum.debian.net>
	<20070612135010.GA12601@srcf.ucam.org>
	<20070612141714.GB20408@khazad-dum.debian.net>
	<20070612153828.GA13888@srcf.ucam.org>
	<466EBFF0.70100@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:8625 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717AbXFLQbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jun 2007 12:31:15 -0400
In-Reply-To: <466EBFF0.70100@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Arjan van de Ven <arjan@linux.intel.com>, Dagfinn Ilmari =?ISO-8859-1?B?TWFubnPla2Vy?= <ilmari@ilmari.org>, james.bottomley@steeleye.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com

On Tue, 12 Jun 2007 11:46:56 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> Matthew Garrett wrote:
> > On Tue, Jun 12, 2007 at 11:17:14AM -0300, Henrique de Moraes Holschuh wrote:
> >> On Tue, 12 Jun 2007, Matthew Garrett wrote:
> >>> Laptop bays are designed to deal with hotplugging PATA - I don't think 
> >>> this is too much of an issue :)
> >> The new SATA ones use the SATA hardware hotplug ;-)   Just like the pci-e
> >> cards use usb2.0 and pci-e hotplug...
> > 
> > Yes, but they'll also send an ACPI interrupt even if the SATA host 
> > controller doesn't - it's part of the spec for bays.
> 
> Regardless, having a laptop does not imply having a docking bay.
> 
> 	Jeff
> 

For bay devices, we can use ACPI just like we do now.  For non-bay devices,
we can implement hotplug via polling when ALPM is enabled.  In my experience
most laptop vendors implement extra drive as either PATA in a dock station, 
USB in a dock station, or a bay device either on the dock station, or 
on the laptop itself.


Kristen
