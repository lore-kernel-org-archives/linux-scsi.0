From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 08:52:25 -0500
Message-ID: <20051208135225.GA13122@havoc.gtf.org>
References: <20051208030242.GA19923@srcf.ucam.org> <20051208091542.GA9538@infradead.org> <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:42711 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751184AbVLHNwf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 08:52:35 -0500
Content-Disposition: inline
In-Reply-To: <20051208133945.GA21633@srcf.ucam.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net

On Thu, Dec 08, 2005 at 01:39:45PM +0000, Matthew Garrett wrote:
> On Thu, Dec 08, 2005 at 01:33:08PM +0000, Christoph Hellwig wrote:
> 
> > Don't do it at all.  We don't need to fuck up every layer and driver for
> > intels braindamage.
> 
> Doing SATA suspend/resume properly on x86 depends on knowing the ACPI 
> object that corresponds to a host or target.

Not true.


> It's also the only way to 
> support hotswap on this hardware[1],

Not true.

	Jeff



