From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] fc transport: new attributes for NPIV
Date: Mon, 9 Jan 2006 18:05:13 +0000
Message-ID: <20060109180513.GA4286@infradead.org>
References: <OFE227A343.800436AC-ON412570ED.0055DD4F-412570ED.00560A75@de.ibm.com> <43BD574D.8040009@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22440 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S964899AbWAISFT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jan 2006 13:05:19 -0500
Content-Disposition: inline
In-Reply-To: <43BD574D.8040009@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Andreas Herrmann <AHERRMAN@de.ibm.com>, James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On Thu, Jan 05, 2006 at 12:28:45PM -0500, James Smart wrote:
> 
> >Problem is that on the mainframe I don't have access to the primary
> >port. Virtualization is done in adapter microcode. I just have
> >access to the virtual port.
> 
> I was afraid you'd say this... that was the other caveat.
> 
> OK - given that the primary port doesn't exist what you have makes
> a lot of sense. I guess we have the 2 options:
> - add the 2 attributes per host
> - create a host and set the attributes  (and this is major overkill)
> 
> I have some reservations about the data passing that allows the virtual
> port to get the physical port data, but it's probably manageable.
> 
> With this direction - your patch is fine, with the caveat that I want
> to explore the most meaningful names for the attributes. Does port_name
> and physical_port_name become odd to a user ? Is some script writer bound
> to assume they always wanted the physical name as they would only see a
> difference if on a mainframe ? What if we change the names to be more
> npiv-centric.  What about ppn (for physical_port_name) and ppn_id (for
> physical_port_id) ?

Actually I think even for Xen-like virtualization it makes most sense that
most domains wouldn't see the Scsi_Host for the phyisical port so this solution
looks most sane to me.  The long name for the physical names sounds fine to me
aswell, much better than un-understandable three-latter acronyms :)

