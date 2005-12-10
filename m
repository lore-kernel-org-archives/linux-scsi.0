From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Sat, 10 Dec 2005 02:47:51 +0000
Message-ID: <20051210024750.GA31328@srcf.ucam.org>
References: <20051209114246.GB16945@infradead.org> <20051209114944.GA1068@havoc.gtf.org> <20051209115235.GB25771@srcf.ucam.org> <43997171.9060105@pobox.com> <20051209121124.GA25974@srcf.ucam.org> <439975AB.5000902@pobox.com> <20051209122457.GB26070@srcf.ucam.org> <439A23E8.3080407@pobox.com> <20051210023426.GA31220@srcf.ucam.org> <439A3FD9.40308@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <439A3FD9.40308@pobox.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Christoph Hellwig <hch@infradead.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, randy_d_dunlap@linux.intel.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Fri, Dec 09, 2005 at 09:39:21PM -0500, Jeff Garzik wrote:
> Matthew Garrett wrote:
> >On Fri, Dec 09, 2005 at 07:40:08PM -0500, Jeff Garzik wrote:
> >
> >
> >>ICH6 and ICH7 support it just fine, through the normal SATA PHY 
> >>registers.  ICH5 only support it if you are clever :)
> >
> >
> >ICH6 supports it even in non-AHCI mode? You may want to update the 
> >website, then :)
> 
> Yes, its a bit outdated.  I just found out that ICH6/7 supports access 
> to SATA PHY registers even in non-AHCI mode.

Oh, cool. That makes life a /lot/ easier - most laptops I've seen using 
SATA are ICH6, so excellent!

> >>Further, although one can detect hot-unplug on ICH5, hotplug is probably 
> >>not detectable without polling or SMI.
> >
> >
> >ACPI allows us to detect hotplug on ICH5, which sounds like a good 
> >argument for its inclusion.
> 
> One special case (ICH5 hotplug, but not ICH5 hot unplug), when all other 
> cases are handled in the normal way?
> 
> That's not a good argument at all.

Well, we could always just add it to ata_piix and leave it out of the 
acpi and scsi layers. I've no great atachment to ACPI - I just want this 
stuff to work :) Basically, ACPI gives us the possibility of making 
hotplug/unplug work on hosts that don't otherwise support it under a 
limited set of conditions. I think that's worthwhile, especially if it 
can be done in a way that doesn't introduce hugely ugly stuff to the 
rest of the kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
