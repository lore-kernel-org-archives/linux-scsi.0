From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Supporting ACPI drive hotswap
Date: Sat, 24 Sep 2005 22:14:15 +0100
Message-ID: <20050924211415.GA26285@srcf.ucam.org>
References: <20050924164823.GA24351@srcf.ucam.org> <20050924124050.1955c290.rdunlap@xenotime.net> <4335ACE9.7070009@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([217.147.92.49]:24813 "EHLO
	vavatch.codon.org.uk") by vger.kernel.org with ESMTP
	id S1750761AbVIXVO2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Sep 2005 17:14:28 -0400
Content-Disposition: inline
In-Reply-To: <4335ACE9.7070009@rtr.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, acpi-support@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Sep 24, 2005 at 03:45:45PM -0400, Mark Lord wrote:
> >Do you know why the ahci driver won't load?
> 
> Undoubtedly the chip is being used in "combined mode",
> to support a PATA ATAPI device on the second channel.
> 
> For that matter, the primary HD is probably actually PATA,
> perhaps with a SATA bridge on the notebook M/B.
> 
> Very very common arrangement these days -- practically all
> Sonoma Centrino chipset notebooks are set up like this.

Yeah, I'd guess something along those lines. The CD drive presents as 
SATA, but looks more like a PATA part. pci_request_regions fails when 
trying to load ahci. It's a Sonoma system (Dell Latitude D610)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
