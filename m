From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 09:45:02 -0800
Message-ID: <20080213094502.4112d5e5@appleyard>
References: <1202172065.3096.154.camel@localhost.localdomain>
	<922945.25870.qm@web31811.mail.mud.yahoo.com>
	<20080212102244.32869382@appleyard>
	<1202841935.3137.94.camel@localhost.localdomain>
	<20080212110752.21840627@appleyard>
	<1202844495.3137.120.camel@localhost.localdomain>
Reply-To: kristen.c.accardi@intel.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934050AbYBMR6s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 12:58:48 -0500
In-Reply-To: <1202844495.3137.120.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

On Tue, 12 Feb 2008 13:28:15 -0600
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2008-02-12 at 11:07 -0800, Kristen Carlson Accardi wrote:
> > I understand what you are trying to do - I guess I just doubt the
> > value you've added by doing this.  I think that there's going to be
> > so much customization that system vendors will want to add, that
> > they are going to wind up adding a custom library regardless, so
> > standardising those few things won't buy us anything.
> 
> It depends ... if you actually have a use for the customisations, yes.
> If you just want the basics of who (what's in the enclousure), what
> (activity) and where (locate) then I think it solves your problem
> almost entirely.
> 
> So, entirely as a straw horse, tell me what else your enclosures
> provide that I haven't listed in the four points.  The SES standards
> too provide a huge range of things that no-one ever seems to
> implement (temperature, power, fan speeds etc).
> 
> I think the users of enclosures fall int these categories
> 
> 85% just want to know where their device actually is (i.e. that sdc is
> in enclosure slot 5)
> 50% like watching the activity lights
> 30% want to be able to have a visual locate function
> 20% want a visual failure indication (the other 80% rely on some OS
> notification instead)
> 
> When you add up the overlapping needs, you get about 90% of people
> happy with the basics that the enclosure services provide.  Could
> there be more ... sure; should there be more ... I don't think so ...
> that's what value add the user libraries can provide.
> 
> James
> 
> 

I don't think I'm arguing whether or not your solution may work, what I
am arguing is really a more philosophical point.  Not "can we do it
this way", but "should we do it way".  I am of the opinion that
management belongs in userspace.  I also am of the opinion that if you
can successfully accomplish something in user space, you should.  I
also believe that even if you provide this basic interface, all system
vendors are going to provide libraries on top of that to customize it,
so you've not added much value to just a simple message passing
interface.

So, I'm happy to defer to Jeff's judgement call here - I just want to
do what's right for our customers and get an enclosure management
interface for SATA exposed, preferrably in time for the 2.6.26 merge
window.  If he prefers your design, I'll disagree, but commit to his
decision and try to get this to work for SATA. If he'd rather see
something along the lines of what I proposed, then since it is 100% self
contained in the SATA subsystem, it shouldn't impact whatever you
want to do in the SCSI subsystem.

Jeff?

