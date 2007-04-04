From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 13:39:19 -0700
Message-ID: <20070404133919.ebcd0ddc.akpm@linux-foundation.org>
References: <200704031508.37222.kern@sibbald.com>
	<20070403145728.d8f83320.akpm@linux-foundation.org>
	<150283e90704032000p7f447a26pe3752b22024a1b67@mail.gmail.com>
	<200704041626.15298.kern@sibbald.com>
	<20070404115536.fd752555.akpm@linux-foundation.org>
	<150283e90704041222v1d8554b6lcb5a6771d4a031b4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55739 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbXDDUkH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Apr 2007 16:40:07 -0400
In-Reply-To: <150283e90704041222v1d8554b6lcb5a6771d4a031b4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: Kern Sibbald <kern@sibbald.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Wed, 4 Apr 2007 12:22:35 -0700
"Willem Riede" <wrlk@riede.org> wrote:

> On 4/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:
> >
> > >  I'm all in favor of deprecating ide-tape if ide-scsi is a viable alternative,
> >
> > ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
> > bugs in it or anything.  The only reason we retain ide-scsi at all is, err,
> > because some tape drives need it.
> >
> > If we have no alternative to using ide-scsi, and if the tape controllers in
> > question are not some terribly obscure things which nobody would seriously
> > use then we have a bit of a problem.  I don't know of anyone who we can
> > turn to to get anything done in ide-scsi.
> 
> Andrew,
> 
> Kai suggests that libata should be able to take over from ide-scsi.
> Do you concur?

That would be very nice if we can make it happen.  I don't know how close
we are to that, but the fine folks on linux-ide might be able tell us.

> That may be a better way forward than ide-scsi.
> I know, because I had a hard enough time with it when I needed
> to fix it so it worked for osst, at least.
> 
> Regards, Willem Riede.
