From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] sysfs: add filter function to groups
Date: Sun, 04 Nov 2007 08:12:02 -0600
Message-ID: <1194185522.3434.7.camel@localhost.localdomain>
References: <1193671019.3383.13.camel@localhost.localdomain>
	 <1193676852.2655.21.camel@lov.site>
	 <1193677071.3383.56.camel@localhost.localdomain>
	 <47261F50.3050901@s5r6.in-berlin.de>
	 <1193768743.3321.91.camel@localhost.localdomain>
	 <20071031035506.GH14910@kroah.com>
	 <1193841484.3411.8.camel@localhost.localdomain>
	 <20071031172943.GA29492@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([64.109.89.108]:34238 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754614AbXKDOMG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Nov 2007 09:12:06 -0500
In-Reply-To: <20071031172943.GA29492@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Kay Sievers <kay.sievers@vrfy.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Wed, 2007-10-31 at 10:29 -0700, Greg KH wrote:
> On Wed, Oct 31, 2007 at 09:38:04AM -0500, James Bottomley wrote:
> > On Tue, 2007-10-30 at 20:55 -0700, Greg KH wrote:
> > > OSame problem here, if grp->is_visible is not set, sysfs_add_file() would
> > > never be called, right?
> > > 
> > > Other than the logic problem (I think), I have no issue with this idea
> > > at all.  Care to redo this so it works?
> > 
> > It's a fair cop govenor ... new patch attached.
> 
> Much better, thanks :)
> 
> I have no problem with this, if you want to take this in your tree,
> please do and feel free to add:
> 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> to it, or I can take it in mine.

Actually, I think I have a use for it and the follow on patch (coming
soon) to do attribute bitmaps in the SCSI tree, so I'd like to add your
ack and take it through this tree.

Thanks,

James


