From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SYM8xx_2 driver ignores certain EEPROM settings
Date: Sun, 2 Jan 2005 01:03:25 +0000
Message-ID: <20050102010325.GJ18080@parcelfarce.linux.theplanet.co.uk>
References: <200412311343.42484.peter.missel@onlinehome.de> <200412311620.44488.peter.missel@onlinehome.de> <m3pt0okd6c.fsf@merlin.emma.line.org> <200501020128.32217.peter.missel@onlinehome.de> <20050102004004.GA25446@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:9153 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S261210AbVABBD0
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Jan 2005 20:03:26 -0500
Content-Disposition: inline
In-Reply-To: <20050102004004.GA25446@merlin.emma.line.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Missel <peter.missel@onlinehome.de>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Sun, Jan 02, 2005 at 01:40:04AM +0100, Matthias Andree wrote:
> Peter Missel schrieb am 2005-01-02:
> 
> > This possibly is because with the exception of the 815 chip, LSI's Narrow 
> > chips don't have a BIOS ROM interface, while the Wide chips do. So if you 
> > were to build a controller card w/ boot ROM support, you had to use a Wide 
> > chip even if the card was to be Narrow-only.
> > 
> > Tekram's 310U, IIRC, was a ROM-less card that used the 860 Narrow
> > chip, wasn't it?
> 
> On the DC-310U, they used a SYM53C860, I'm not sure about the specs of
> the chip now that you write narrow.

This is documented in Documentation/scsi/sym53c8xx_2.txt:

       On board                                   LOAD/STORE   HARDWARE
Chip   SDMS BIOS   Wide   SCSI std.   Max. sync   SCRIPTS      PHASE MISMATCH
----   ---------   ----   ---------   ----------  ----------   --------------
[...]
860        N         N      FAST20    20 MB/s        Y             N

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
