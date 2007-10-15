From: Greg KH <greg@kroah.com>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 10:25:13 -0700
Message-ID: <20071015172513.GA5738@kroah.com>
References: <200710112011.22000.rob@landley.net> <200710141845.44750.rob@landley.net> <20071015060015.GB32268@kroah.com> <200710150336.15774.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932751AbXJOR05@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200710150336.15774.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2007 at 03:36:15AM -0500, Rob Landley wrote:
> 
> The point I was trying to make is that it seems to me like it would be 
> possible to keep the namespace separate here, and thus reduce the enumeration 
> problems to the point where common cases (like my laptop) aren't impacted by 
> them during early boot.

Proposals on how to do this would be gladly reviewed.

But again, please remember that these USB devices are really SCSI
devices.  Same for SATA devices.  There is a reason they are using the
SCSI layer, and it isn't just because the developers felt like it :)

> I don't think anybody (outside the embedded space) is actually upset
> that /dev/hda now goes through the scsi layer:  they're upset Ubuntu
> 7.04 no longer calls it /dev/hda.

Use mount-by-label instead, it's much saner and handles device name
movement just fine (as does the UUID method that you seem to hate.)
Look in /dev/disk/ for a wide range of options that you have in which to
choose how to pick your block devices.

Oh, and this seems like a very Ubuntu specific rant, might I suggest you
contact the Ubuntu developers about this?  The kernel doesn't dictate
that the distro has to use these long identifiers, and there is nothing
we can do about it.

good luck,

greg k-h
