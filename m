From: Greg KH <greg@kroah.com>
Subject: Re: USB regression (and other failures) in 2.6.2[45]* - mostly
	resolved
Date: Thu, 21 Feb 2008 09:17:26 -0800
Message-ID: <20080221171726.GA30927@kroah.com>
References: <47BDA141.70806@gmail.com> <Pine.LNX.4.44L0.0802211134040.4528-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:45907 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYBURWg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Feb 2008 12:22:36 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802211134040.4528-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Andrew Buehler <abuehler.kernel@gmail.com>, Oliver Pinter <oliver.pntr@gmail.com>, Kernel development list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Thu, Feb 21, 2008 at 11:36:23AM -0500, Alan Stern wrote:
> On Thu, 21 Feb 2008, Andrew Buehler wrote:
> 
> > On 2/20/2008 2:29 PM, Alan Stern wrote:
> > 
> > > On Wed, 20 Feb 2008, Andrew Buehler wrote:
> > > 
> > >> In other words: I don't think that's likely to be practical in the
> > >> present instance. If you have reason to believe otherwise (past
> > >> positive experience with Novell, for instance), I'd be glad to hear
> > >> it.
> > > 
> > > Greg KH may be able to help in that respect.
> > 
> > I know he's in the CC:, but I'm not sure he's reading this thread, and
> > I'm hesitant to bother people about things out of the blue unless I have
> > reason to expect that it's something they're going to care about. (Just
> > because it's a big deal for me doesn't mean it makes one whit of
> > difference to anyone else, and from what little I've seen on
> > linux-kernel he seems to be somewhat important and fairly busy...)
> 
> In this case you shouldn't worry about it.  I don't know whether Greg
> has been following this thread either, but I do know that he spends a
> lot of time and effort trying to improve vendors' support for Linux.  
> This is right up his alley.  What I'm not sure about is the extent of
> his influence over Novell...

Heh, yes, I've been reading this.

It sounds like an old version of a Novell product is making a newer
kernel spit out a warning message.  Odds are this is fixed in a newer
one, as well as the basic issue that Novell doesn't even ship anything
based on the 2.6.24 kernel yet, so perhaps the Zenworks developers don't
even know of the issue, that's what bugzilla.novell.com is for :)

thanks,

greg k-h
