From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 13:44:38 +0000
Message-ID: <20051208134438.GA13507@infradead.org>
References: <20051208030242.GA19923@srcf.ucam.org> <20051208091542.GA9538@infradead.org> <20051208132657.GA21529@srcf.ucam.org> <20051208133308.GA13267@infradead.org> <20051208133945.GA21633@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22506 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932092AbVLHNoj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Dec 2005 08:44:39 -0500
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
> object that corresponds to a host or target. It's also the only way to 
> support hotswap on this hardware[1], since there's no way for userspace 
> to know which device a notification refers to.

Well, bad luck for people buying such broken hardware.  Maybe you can trick
Jeff into adding junk like that to libata, but it surely doesn't have any
business in the scsi layer.

Why oh why do our chipset friends at intel have to fuck up everything they
can?  I wish they'd learn a lesson or two from their cpu collegues.
