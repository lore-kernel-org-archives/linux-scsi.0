From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: Linux tape drivers
Date: Wed, 4 Apr 2007 23:31:06 +0200
Message-ID: <200704042331.06105.bzolnier@gmail.com>
References: <200704031508.37222.kern@sibbald.com> <150283e90704041222v1d8554b6lcb5a6771d4a031b4@mail.gmail.com> <20070404133919.ebcd0ddc.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070404133919.ebcd0ddc.akpm@linux-foundation.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Willem Riede <wrlk@riede.org>, Kern Sibbald <kern@sibbald.com>, Kai Makisara <Kai.Makisara@kolumbus.fi>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 04 April 2007, Andrew Morton wrote:
> On Wed, 4 Apr 2007 12:22:35 -0700
> "Willem Riede" <wrlk@riede.org> wrote:
> 
> > On 4/4/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 4 Apr 2007 16:26:14 +0200 Kern Sibbald <kern@sibbald.com> wrote:
> > >
> > > >  I'm all in favor of deprecating ide-tape if ide-scsi is a viable alternative,
> > >
> > > ow.  ide-scsi is in very bad shape and nobody is maintaining it or fixing
> > > bugs in it or anything.  The only reason we retain ide-scsi at all is, err,

I haven't heard about any major bugs besides well known module unload problem.

What have I missed?

> > > because some tape drives need it.
> > >
> > > If we have no alternative to using ide-scsi, and if the tape controllers in
> > > question are not some terribly obscure things which nobody would seriously
> > > use then we have a bit of a problem.  I don't know of anyone who we can
> > > turn to to get anything done in ide-scsi.
> > 
> > Andrew,
> > 
> > Kai suggests that libata should be able to take over from ide-scsi.
> > Do you concur?
> 
> That would be very nice if we can make it happen.  I don't know how close
> we are to that, but the fine folks on linux-ide might be able tell us.
> 
> > That may be a better way forward than ide-scsi.
> > I know, because I had a hard enough time with it when I needed
> > to fix it so it worked for osst, at least.
> > 
> > Regards, Willem Riede.
