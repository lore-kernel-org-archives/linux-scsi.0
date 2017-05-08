From: Pavel Machek <pavel@ucw.cz>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 23:36:05 +0200
Message-ID: <20170508213605.GA12687@amd>
References: <1494228094.6528.14.camel@infradead.org>
 <alpine.DEB.2.11.1705080930150.6882@lnxricardw1>
 <1494231215.6528.22.camel@infradead.org>
 <alpine.DEB.2.11.1705081034420.6882@lnxricardw1>
 <1494233673.6528.28.camel@infradead.org>
 <alpine.DEB.2.11.1705081059580.6882@lnxricardw1>
 <7ee84982-cfad-94d7-4e22-4edbeb852b32@redhat.com>
 <1494238390.6528.42.camel@infradead.org>
 <20170508135005.0b9b200b@bbrezillon>
 <1494258011.5407.18.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494258011.5407.18.camel@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>, Hans de Goede <hdegoede@redhat.com>, Ricard Wanderlof <ricard.wanderlof@axis.com>, Tejun Heo <tj@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
List-Id: linux-scsi@vger.kernel.org

On Mon 2017-05-08 16:40:11, David Woodhouse wrote:
> On Mon, 2017-05-08 at 13:50 +0200, Boris Brezillon wrote:
> > On Mon, 08 May 2017 11:13:10 +0100
> > David Woodhouse <dwmw2@infradead.org> wrote:
> > 
> > > 
> > > On Mon, 2017-05-08 at 11:09 +0200, Hans de Goede wrote:
> > > > 
> > > > You're forgetting that the SSD itself (this thread is about SSDs) also has
> > > > a major software component which is doing housekeeping all the time, so even
> > > > if the main CPU gets reset the SSD's controller may still happily be erasing
> > > > blocks.  
> > > We're not really talking about SSDs at all any more; we're talking
> > > about real flash with real maintainable software.
> >
> > It's probably a good sign that this new discussion should take place in
> > a different thread :-).
> 
> Well, maybe. But it was a silly thread in the first place. SATA SSDs
> aren't *expected* to be reliable.

Citation needed?

I'm pretty sure SATA SSDs are expected to be reliable, up to maximum
amount of gigabytes written (specified by manufacturer), as long as
you don't cut power without warning.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
