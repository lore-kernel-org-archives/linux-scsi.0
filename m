From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH] Ghost devices being reported with AIC7XXX version 6.2.6
Date: Thu, 31 Oct 2002 15:43:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021031204309.GH30047@redhat.com>
References: <20021031201717.GF30047@redhat.com> <Pine.BSF.4.21.0210311220550.23076-100000@beppo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.BSF.4.21.0210311220550.23076-100000@beppo>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <mjacob@feral.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Justin T. Gibbs" <gibbs@scsiguy.com>, Mike Brown <mbrown@emc.com>, bferjul@emc.com, jkrasner@emc.com, conway_heather@emc.com, linux-scsi@vger.kernel.org

On Thu, Oct 31, 2002 at 12:27:44PM -0800, Matthew Jacob wrote:
> > On Thu, Oct 31, 2002 at 12:04:16PM -0800, Matthew Jacob wrote:
> > > 
> > > *blush*
> > > 
> > > I was actually going to start finally working 2.5 next week (don't hit
> > > me! don't hit me)
> > 
> > Hehehe!  Going to start after the feature freeze is already over, makes it 
> > kind of hard to get anything new in doesn't it ;-)
> 
> Well, look- doing feature freezes early is all well and swell, but
> remember that a lot of us out here, if we get any work stuff at all for
> Linux, has us concentrate on 2.4, or even 2.2.

Yes, I know, that's why there was a wink-smiley there.

> driver subsystems are candidates for late binding and late changing
> because they are typically isolated areas.

As well as they are here.  At least driver updates anyway.  Driver 
subsystem changes are a bit harder to get in, especially if they stand a 
chance of breaking other working drivers.


-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
