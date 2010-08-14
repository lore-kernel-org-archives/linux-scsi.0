From: Stefan Schmitt <development.stefan@alice.de>
Subject: Re: Interest in a driver for PCMCIA Bus toaster (New Media) with advansys chip set?
Date: Sat, 14 Aug 2010 22:57:57 +0200
Message-ID: <201008142257.57197.development.stefan@alice.de>
References: <201008141934.05664.development.stefan@alice.de> <20100814183713.GE12892@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:58508 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755973Ab0HNVNw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Aug 2010 17:13:52 -0400
In-Reply-To: <20100814183713.GE12892@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Saturday 14 August 2010 at 20:37:14 Matthew Wilcox wrote:
> On Sat, Aug 14, 2010 at 07:34:05PM +0200, Stefan Schmitt wrote:
> > Hallo,
> >
> > the card is labelled PS: 404-15-02A. As much as I could see, there
> > is no linux driver available.
> >
> >         Product Name:   PCMCIA Bus Toaster SCSI Adapter
> >         Identification: manf_id: 0x10cd card_id: 0x0001
> >                  function: 8 (SCSI)
> >                  prod_id(1): "PCMCIA Bus Toaster" (0x590031a6)
> >                  prod_id(2): "SCSI Adapter" (0x96269fcd)
> >
> > I have an initial version of driver code (for the 2.6 kernel). I could
> > send the code to someone more experienced if there is interest.
> 
> Is it (in any way) similar to the PCI/ISA advansys chipsets?  (see
> drivers/scsi/advansys.c)  If so, we should probably merge the drivers.
> 
the code is sort of similar, so maybe this could be done. Here are the main 
differences:

 (1) the PCMCIA card uses memory mapped IO in contrast to the PCI/ISA drivers
 (2) the PCMCIA card does not do DMA [at least not on my computer] so there is 
an extra part in the driver for doing PIO.

I also experienced some difficulties with a few other parts of the PCI/ISA 
driver code and this PCMCIA board. The microcode can be shared in any case.
