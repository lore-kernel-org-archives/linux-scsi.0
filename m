From: Theodore Tso <tytso@mit.edu>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 09:35:50 -0400
Message-ID: <20071015133549.GF21216@thunk.org>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015014503.GF9715@thunk.org> <200710150304.00901.rob@landley.net> <20071015132106.GE21216@thunk.org> <20071015142945.2cb27911@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:58098 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453AbXJONgc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Oct 2007 09:36:32 -0400
Content-Disposition: inline
In-Reply-To: <20071015142945.2cb27911@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rob Landley <rob@landley.net>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Mon, Oct 15, 2007 at 02:29:45PM +0100, Alan Cox wrote:
> > You can pull a Model and Serial number via hdparm -i, but it's not as
> > easy to manipulate as a fixed-length MAC address.  That's why people
> > tend to use filesystem UUID's.   
> 
> ATA8 at the moment looks set to add a true "MAC" or "WWN" type identifier
> to each device.. Right now model/serial is not always unique.

True, but most manufacturers try to make the serial number unique for
their own reasons (like warrantee service), and you can have
manufacturing errors with MAC assignment just as easily as you can
with serial numbers.

I still remember when SGI shipped MIT 20 SGI Indy pizza boxes that all
had the same MAC addresses (that we knew about --- we found out
because all 20 were installed on the same subnet).  That was a mildly
entertaining bug to track down....  especially since IIRC, Irix at the
time didn't print warning messages when someone else with a different
IP addresses responded to your MAC address.

   						- Ted
