From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 7/9] exofs: mkexofs
Date: Sun, 4 Jan 2009 10:38:41 -0500
Message-ID: <20090104153841.GA16569@infradead.org>
References: <4947BFAA.4030208@panasas.com> <4947CA5C.50104@panasas.com> <20081229121423.efde9d06.akpm@linux-foundation.org> <495B8D90.1090004@panasas.com> <1230739053.3408.74.camel@localhost.localdomain> <4960D3CA.2000202@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58207 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680AbZADPkD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Jan 2009 10:40:03 -0500
Content-Disposition: inline
In-Reply-To: <4960D3CA.2000202@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Benny Halevy <bhalevy@panasas.com>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@ZenIV.linux.org.uk>, Avishay Traeger <avishay@gmail.com>, open-osd development <osd-dev@open-osd.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sun, Jan 04, 2009 at 05:20:42PM +0200, Boaz Harrosh wrote:
> 
> User-mode Interface is another matter. There are some ideas and some already
> implemented.
> [Hosted on open-osd.org
>  see: http://git.open-osd.org/gitweb.cgi?p=osc-osd/.git;a=summary
>  look inside the osd-initiator directory]
> And I have a toy interface that adds no new entries into the Kernel in
> the form of an OSDVFS module, that will let you access the raw OSD device
> through the VFS name-space.
> 
> The lack of any user-mode API is just the lack of any current need/priority,
> or that I'm the only one working on OSD. But nothing that could not be solved
> in two weeks of pragmatic work. Surly it's not a paradigm problem.

For mkfs/repair direct use by databases, etc you want a userspace
library, too.  The easiest way to get started would to simply take the
kernel libosd and make it work ontop of SG_IO.

