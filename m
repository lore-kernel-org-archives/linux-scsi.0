From: Dave Jones <davej@redhat.com>
Subject: Re: advansys pci tweaks.
Date: Wed, 2 Aug 2006 17:39:36 -0400
Message-ID: <20060802213936.GD3639@redhat.com>
References: <20060802211149.GC3639@redhat.com> <20060802213420.GG7606@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:20889 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932223AbWHBVjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2006 17:39:44 -0400
Content-Disposition: inline
In-Reply-To: <20060802213420.GG7606@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, bobf@advansys.com

On Wed, Aug 02, 2006 at 03:34:20PM -0600, Matthew Wilcox wrote:
 > On Wed, Aug 02, 2006 at 05:11:49PM -0400, Dave Jones wrote:
 > > Remove a lot of duplicate #defines from the advansys driver,
 > > and make them look like PCI IDs as defined elsewhere in the kernel.
 > > Also add a module table so that it automatically gets picked up
 > > by tools relying on modinfo output (like say, distro installers).
 > 
 > I'd much rather see at least the vendor ID moved to pci_ids.h; how about
 > #define PCI_VENDOR_ID_ADVSYS            0x10cd
 > for that one?

I actually did this in the first iteration of this patch
(In fact, I had all the device IDs there too). I decided against
that because there weren't any other users of the ID in the tree,
and I doubt we'll be seeing new drivers from this vendor ID any time soon.

I've no real objection either way though.

 > > @@ -889,10 +889,6 @@ typedef unsigned char uchar;
 > >  #define ASC_PCI_ID2DEV(id)    (((id) >> 11) & 0x1F)
 > >  #define ASC_PCI_ID2FUNC(id)   (((id) >> 8) & 0x7)
 > >  #define ASC_PCI_MKID(bus, dev, func) ((((dev) & 0x1F) << 11) | (((func) & 0x7) << 8) | ((bus) & 0xFF))

I did have a series of other patches for advansys, I'm fairly certain
this and more got cleaned up, but I've forgotten where I've left them.
(You know you've too many test boxes when...)

If I unearth them, I'll post them too.

 > ... those all need to be fixed too.  Sigh.  I wonder if Bob Frey is
 > still around to care about this driver ...

I was under the impression Advansys were no more ?

		Dave

-- 
http://www.codemonkey.org.uk
