From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 13:37:08 -0700
Message-ID: <20070404133708.6cfbe192.akpm@linux-foundation.org>
References: <200704031508.37222.kern@sibbald.com>
	<200704041626.15298.kern@sibbald.com>
	<20070404115536.fd752555.akpm@linux-foundation.org>
	<200704042121.09399.kern@sibbald.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55648 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXDDUh4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2007 16:37:56 -0400
In-Reply-To: <200704042121.09399.kern@sibbald.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kern Sibbald <kern@sibbald.com>
Cc: Willem Riede <wrlk@riede.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org

On Wed, 4 Apr 2007 21:21:08 +0200
Kern Sibbald <kern@sibbald.com> wrote:

> On Wednesday 04 April 2007 20:55, Andrew Morton wrote:
> > On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:
> > 
> > >  I'm all in favor of deprecating ide-tape if ide-scsi is a viable 
> alternative, 
> > 
> > ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
> > bugs in it or anything.  The only reason we retain ide-scsi at all is, err,
> > because some tape drives need it.
> > 
> > If we have no alternative to using ide-scsi, and if the tape controllers in
> > question are not some terribly obscure things which nobody would seriously
> > use then we have a bit of a problem.  I don't know of anyone who we can
> > turn to to get anything done in ide-scsi.
> > 
> >
> 
> That's quite clear, thanks.  I'll update our documentation to say that 
> ide-scsi doesn't work with Bacula, is not actively supported and may be 
> removed from the kernel.

That seems like a good idea, I'm afraid.

> What non-SCSI drivers do you feel are or should be well supported?
> libata as Kai indicates?

I don't know this stuff well enough to be able to answer that usefully,
sorry.

> Once I am sure, I'll point Bacula users to those drivers.  
