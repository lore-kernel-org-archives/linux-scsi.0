From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 13:31:44 -0800
Message-ID: <20051208133144.0f39cb37.randy_d_dunlap@linux.intel.com>
References: <20051208030242.GA19923@srcf.ucam.org>
	<20051208091542.GA9538@infradead.org>
	<20051208132657.GA21529@srcf.ucam.org>
	<20051208133308.GA13267@infradead.org>
	<20051208133945.GA21633@srcf.ucam.org>
	<20051208134438.GA13507@infradead.org>
	<1134062330.1732.9.camel@localhost.localdomain>
	<43989B00.5040503@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmr17.intel.com ([134.134.136.16]:6631 "EHLO
	orsfmr002.jf.intel.com") by vger.kernel.org with ESMTP
	id S932398AbVLHV3U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 16:29:20 -0500
In-Reply-To: <43989B00.5040503@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: erik@slagter.name, hch@infradead.org, mjg59@srcf.ucam.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Thu, 08 Dec 2005 15:43:44 -0500
Jeff Garzik <jgarzik@pobox.com> wrote:

> Erik Slagter wrote:
> > 'guess You're not interested in having suspend/resume actually work on
> > laptops (or other PC's). That's your prerogative but imho it's a bit
> > narrow-minded to withhold this functionality from other people who
> > actually would like to have this working, just because you happen to not
> > like ACPI.
> 
> It works just fine on laptops, with Jens' suspend/resume patch.

I have seen a few other people report that SATA suspend/resume
works when using Jens's patch.  However, this is done without
the benefit of what the additional ACPI methods provide thru
_GTF and writing those taskfiles, such as:
- enabling write cache
- enabling device power management
- freezing the security password

so even when it "works," those people may be missing some
performance benefits or power savings or security.

In any case, I'm glad to see some discussion of this.

---
~Randy
