From: Matthew Wilcox <willy@debian.org>
Subject: Re: Ultra160 controller on 32bit pci
Date: Thu, 6 May 2004 16:29:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040506152923.GB2281@parcelfarce.linux.theplanet.co.uk>
References: <4099F408.E424C26A@danbbs.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:14283 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S262605AbUEFP3Y
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2004 11:29:24 -0400
Content-Disposition: inline
In-Reply-To: <4099F408.E424C26A@danbbs.dk>
List-Id: linux-scsi@vger.kernel.org
To: Mogens Valentin <monz@danbbs.dk>
Cc: Linux-scsi <linux-scsi@vger.kernel.org>

On Thu, May 06, 2004 at 10:15:04AM +0200, Mogens Valentin wrote:
> Currently using Adaptec 29160, works fine, but it's only 160/2, after
> all.
> I'm curious if other controllers can provide better performance when
> used on a 32bit pci bus?

Theoretical bandwidth on a 33MHz 32-bit PCI bus is around 132MB/s.
In practice you never attain that because of overhead in turning the bus
around and typical figures quoted in the PCI spec are between 60-107MB/s.
So you already saturated the PCI bus (never mind what else you have on that
bus).

> In a few month I might switch to a pci-express/opteron setup, so I'd
> like some indication about controllers for that bus.

Depends what people are going to ship.  I've heard rumours the initial
chipsets will have an x16 link for graphics and an x4 link for other I/O.
Express gives you 256MB/s in each direction for an x1 link, so expect
to get 1GB/s *in each direction* from an Express SCSI card.  Will there
be parallel SCSI Express cards?  Not sure, everything seems to indicate
SAS instead.

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
