From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Sat, 16 Feb 2008 12:44:58 +0000
Message-ID: <20080216124458.GA3979@ucw.cz>
References: <1202172065.3096.154.camel@localhost.localdomain> <922945.25870.qm@web31811.mail.mud.yahoo.com> <20080212102244.32869382@appleyard> <1202841935.3137.94.camel@localhost.localdomain> <20080212110752.21840627@appleyard> <1202844495.3137.120.camel@localhost.localdomain> <20080213094502.4112d5e5@appleyard>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4520 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934AbYBSSpf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 13:45:35 -0500
Content-Disposition: inline
In-Reply-To: <20080213094502.4112d5e5@appleyard>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

On Wed 2008-02-13 09:45:02, Kristen Carlson Accardi wrote:
> On Tue, 12 Feb 2008 13:28:15 -0600
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Tue, 2008-02-12 at 11:07 -0800, Kristen Carlson Accardi wrote:
> > > I understand what you are trying to do - I guess I just doubt the
> > > value you've added by doing this.  I think that there's going to be
> > > so much customization that system vendors will want to add, that
> > > they are going to wind up adding a custom library regardless, so
> > > standardising those few things won't buy us anything.
> > 
> > It depends ... if you actually have a use for the customisations, yes.
> > If you just want the basics of who (what's in the enclousure), what
> > (activity) and where (locate) then I think it solves your problem
> > almost entirely.
> > 
> > So, entirely as a straw horse, tell me what else your enclosures
> > provide that I haven't listed in the four points.  The SES standards
> > too provide a huge range of things that no-one ever seems to
> > implement (temperature, power, fan speeds etc).
> > 
> > I think the users of enclosures fall int these categories
> > 
> > 85% just want to know where their device actually is (i.e. that sdc is
> > in enclosure slot 5)
> > 50% like watching the activity lights
> > 30% want to be able to have a visual locate function
> > 20% want a visual failure indication (the other 80% rely on some OS
> > notification instead)
> > 
> > When you add up the overlapping needs, you get about 90% of people
> > happy with the basics that the enclosure services provide.  Could
> > there be more ... sure; should there be more ... I don't think so ...
> > that's what value add the user libraries can provide.
> > 
> > James
> > 
> > 
> 
> I don't think I'm arguing whether or not your solution may work, what I
> am arguing is really a more philosophical point.  Not "can we do it
> this way", but "should we do it way".  I am of the opinion that

Hw abstraction is still kernel's job. That's why we have leds exported
in sysfs... let vendors have their libraries, but lets put the
'everyone does these' stuff in kernel.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
