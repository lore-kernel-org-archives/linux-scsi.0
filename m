From: Peter Missel <peter.missel@onlinehome.de>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sun, 2 Jan 2005 10:58:24 +0100
Message-ID: <200501021058.24455.peter.missel@onlinehome.de>
References: <200412311343.42484.peter.missel@onlinehome.de> <20050102004004.GA25446@merlin.emma.line.org> <20050102010325.GJ18080@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.185]:40928 "EHLO
	moutng.kundenserver.de") by vger.kernel.org with ESMTP
	id S261181AbVABJ6t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jan 2005 04:58:49 -0500
In-Reply-To: <20050102010325.GJ18080@parcelfarce.linux.theplanet.co.uk>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Sunday 02 January 2005 02:03, Matthew Wilcox wrote:
> On Sun, Jan 02, 2005 at 01:40:04AM +0100, Matthias Andree wrote:
> > Peter Missel schrieb am 2005-01-02:
> > > This possibly is because with the exception of the 815 chip, LSI's
> > > Narrow chips don't have a BIOS ROM interface, while the Wide chips do.
> > > So if you were to build a controller card w/ boot ROM support, you had
> > > to use a Wide chip even if the card was to be Narrow-only.
> > >
> > > Tekram's 310U, IIRC, was a ROM-less card that used the 860 Narrow
> > > chip, wasn't it?
> >
> > On the DC-310U, they used a SYM53C860, I'm not sure about the specs of
> > the chip now that you write narrow.
>
> This is documented in Documentation/scsi/sym53c8xx_2.txt:
>
>        On board                                   LOAD/STORE   HARDWARE
> Chip   SDMS BIOS   Wide   SCSI std.   Max. sync   SCRIPTS      PHASE
> MISMATCH ----   ---------   ----   ---------   ----------  ----------  
> -------------- [...]
> 860        N         N      FAST20    20 MB/s        Y             N

Having used the 860 in various mainboard designs at work, I confirm this to be 
correct - 20 MT/s (from an 80 MHz clock!), narrow, no ROM interface, no SSID.
