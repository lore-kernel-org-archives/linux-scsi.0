From: Christoph Hellwig <hch@infradead.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Thu, 8 Dec 2005 13:33:08 +0000
Message-ID: <20051208133308.GA13267@infradead.org>
References: <20051208030242.GA19923@srcf.ucam.org> <20051208091542.GA9538@infradead.org> <20051208132657.GA21529@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932078AbVLHNdN@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20051208132657.GA21529@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Christoph Hellwig <hch@infradead.org>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 08, 2005 at 01:26:57PM +0000, Matthew Garrett wrote:
> On Thu, Dec 08, 2005 at 09:15:42AM +0000, Christoph Hellwig wrote:
> 
> > NACK.  ACPI-specific hacks do not have any business at all in the scsi layer.
> 
> Ok. What's the right layer to do this? The current ACPI/anything else 
> glue depends on specific knowledge about the bus concerned, and needs 
> callbacks registered before devices are added to that bus. Doing it in 
> the sata layer would have the potential for unhappiness on mixed 
> sata/scsi machines.

Don't do it at all.  We don't need to fuck up every layer and driver for
intels braindamage.
