From: Greg KH <greg@kroah.com>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 21:21:04 -0700
Message-ID: <20071016042104.GA7854@kroah.com>
References: <200710112011.22000.rob@landley.net> <200710150304.00901.rob@landley.net> <646765f40710150206j75af4c4dwac4f4565451b64b1@mail.gmail.com> <200710150508.37332.rob@landley.net> <20071015173357.GB5738@kroah.com> <Pine.LNX.4.64.0710151952250.3949@asgard.lang.hm> <20071016040401.GA15744@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52070 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbXJPEVR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 00:21:17 -0400
Content-Disposition: inline
In-Reply-To: <20071016040401.GA15744@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: david@lang.hm, Rob Landley <rob@landley.net>, Julian Calaby <julian.calaby@gmail.com>, Theodore Tso <tytso@mit.edu>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Mon, Oct 15, 2007 at 10:04:01PM -0600, Matthew Wilcox wrote:
> On Mon, Oct 15, 2007 at 07:54:22PM -0700, david@lang.hm wrote:
> > do PCI devices reorder their bus numbers spontaniously, or only if you 
> > change the hardware?
> 
> The only system I've had that reordered PCI bus numbers was when I had a
> partitionable system and changed the partitioning.  Not quite "change
> the hardware", but neither was it "spontaneous".  It was certainly
> unexpected (for me).
> 
> Greg probably has quite different examples.

Changing the hardware (adding a new PCI device or removing one) are the
most common times this happens.  But I have seen reports of this
happening when you upgrade/downgrade BIOS versions, and, in some
oops-we-messed-up cases, when we changed things in the kernel.

thanks,

greg k-h
