From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as84) Fix a mistake in scsi_proc.c
Date: Fri, 26 Sep 2003 12:22:25 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0309261219160.5938-100000@ida.rowland.org>
References: <1064592414.1781.8.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:14084 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S261448AbTIZQW0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 12:22:26 -0400
In-Reply-To: <1064592414.1781.8.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On 26 Sep 2003, James Bottomley wrote:

> On Fri, 2003-09-26 at 11:03, Alan Stern wrote:
> > I tried sending this patch to Mike Anderson a couple of times, but never
> > got any response.  It's an obvious fix for a mistake in a section of code
> > I sent to him last spring: an error path fails to release a mutex.
> > 
> > If you don't see anything wrong here, please apply it.
> 
> It's already in the scsi-misc-2.5 BK tree
> 
> http://linux-scsi.bkbits.net:8080/scsi-misc-2.5/cset@1.1239.1.2?nav=index.html|ChangeSet@-1d

Oh, okay -- thanks.  I've just been looking at Linus's tree, which doesn't
have it yet.  But it seems safe to assume it will percolate up there at
some point soon.

Alan Stern

