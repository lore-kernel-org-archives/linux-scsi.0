From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qlogic qla2312f-v2 (hp oem?)
Date: Wed, 14 Jun 2006 15:45:52 -0700
Message-ID: <20060614224551.GR879@andrew-vasquezs-powerbook-g4-15.local>
References: <7.0.1.0.0.20060609132026.025d7098@elexis.nl> <20060609120853.GL1651@parisc-linux.org> <7.0.1.0.0.20060614095006.041f7cf0@elexis.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:23004 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S964910AbWFNWpy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jun 2006 18:45:54 -0400
Content-Disposition: inline
In-Reply-To: <7.0.1.0.0.20060614095006.041f7cf0@elexis.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sander van Beek - Elexis <sander@elexis.nl>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org

On Wed, 14 Jun 2006, Sander van Beek - Elexis wrote:

> Thanks for your reply.
> I've tried this, but the driver still does not seem to recognize the 
> card. Any other idea's?

I'd suggest you contact QLogic's tech-support:

http://support.qlogic.com/support/report_problem.asp


I'm unaware of any DID of 0x8000:

> At 14:08 9-6-2006, Matthew Wilcox wrote:
> >On Fri, Jun 09, 2006 at 01:20:57PM +0200, Sander van Beek - Elexis wrote:
> >> I recently got two qla2312f-v2 cards from ebay. These are dual 2gbit
> >> fibre channel hba's for a pci-x bus. The qlogic site says this type
> >> is a HP OEM card and it is not sold directly by qlogic.
> >> I tried to get them working on a slackware 10.2 system with the
> >> latest stable 2.6 kernel. However, the qla2xxx driver does not see
> >> the card. My dmesg only shows this line:
> >>
> >> Jun  9 11:09:27 clust1 kernel: QLogic Fibre Channel HBA Driver
> >>
> >> This is how the card shows up in my /proc/pci:
> >>
> >>   Bus  2, device   1, function  1:
> >>     Class 0c04: PCI device 1077:8000 (rev 1).
> >>       IRQ 255.
> >>       Prefetchable 32 bit memory at 0x40000000 [0x403fffff].

weird...

--
Andrew
