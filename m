From: Grant Grundler <grundler@parisc-linux.org>
Subject: Re: i450nx-scanning-fix.patch
Date: Tue, 30 Dec 2003 12:18:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031230191854.GB19852@colo.lackof.org>
References: <20031229030235.315d5502.akpm@osdl.org> <20031229122809.GF12479@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from colo.lackof.org ([198.49.126.79]:28304 "EHLO colo.lackof.org")
	by vger.kernel.org with ESMTP id S265889AbTL3TSz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Dec 2003 14:18:55 -0500
Content-Disposition: inline
In-Reply-To: <20031229122809.GF12479@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz

On Mon, Dec 29, 2003 at 12:28:09PM +0000, Matthew Wilcox wrote:
> Well, I made the same mistake in this patch as I made in a later patch, so
> I know it never worked for anyone.  Namely, pci_bus->children is the list
> of child busses, not the list of devices on the bus.  That's ->devices.

Yeah - it's not obvious unless one looks at the types carefully.

> I swear I'm going to write a for_each_pci_device_on_this_bus() macro so
> I don't make the same mistake a third time.

Can we rename "children" to "secondary_busses" or something like that?

grant
