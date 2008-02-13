From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Wed, 13 Feb 2008 03:15:41 -0800 (PST)
Message-ID: <172410.55272.qm@web31808.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:25942 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751527AbYBMLPq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Feb 2008 06:15:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kristen.c.accardi@intel.com, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org

--- On Tue, 2/12/08, James Bottomley James.Bottomley@HansenPartnership.com> wrote:
> > I understand what you are trying to do - I guess I
> just doubt the value
> > you've added by doing this.  I think that
> there's going to be so much
> > customization that system vendors will want to add,
> that they are going
> > to wind up adding a custom library regardless, so
> standardising those
> > few things won't buy us anything.
> 
> It depends ... if you actually have a use for the
> customisations, yes.
> If you just want the basics of who (what's in the
> enclousure), what
> (activity) and where (locate) then I think it solves your
> problem almost
> entirely.

If the kernel doesn't solve it "entirely", then it is better
off without the kernel bloat.  In fact vendors would distribute
their own user-space application(s) to provide a consistent and
complete solution(s) of their product(s) to their customer(s).

This could also be achieved via "sg_ses", which can also
control custom vendor pages if the encodings are known by the
customer (which they would be if they purchased the product).

> So, entirely as a straw horse, tell me what else your
> enclosures provide
> that I haven't listed in the four points.

You shouldn't insist on this.  It should already be clear
to you this direction isn't the vendor's preference.

>  The SES
> standards too provide
> a huge range of things that no-one ever seems to implement
> (temperature,
> power, fan speeds etc).

Vendors do use "temperature, power and fan speeds" and
in fact more features, some of them completely custom
for their product, since they end up writing the SES
device server of the enclosure themselves (for their product).
This kind of control and representation is better left to
user-space.  The kernel neither needs to represent it
nor know about it, since it is itself not using nor
controlling it.

> I think the users of enclosures fall int these categories

This statement (above) really means that the numbers below
are but merely the speculation of one person.

> 
> 85% just want to know where their device actually is (i.e.
> that sdc is
> in enclosure slot 5)
> 50% like watching the activity lights
> 30% want to be able to have a visual locate function
> 20% want a visual failure indication (the other 80% rely on
> some OS
> notification instead)
> 
> When you add up the overlapping needs, you get about 90% of
> people happy
> with the basics that the enclosure services provide.

90% doesn't make it a necessary requirement for the kernel
to have this, as well as the fact that the kernel is neither
needing this to function properly, nor using it.

> Could there be more ... sure; should there be more ... I don't think
> so ... that's what value add the user libraries can provide.

"should there be more ... I don't think so"

This decision isn't yours to make.  In fact such a decision is never
made by one person only.  This decision is made by 1) the industry,
2) the customers and 3) vendors by the pricing of their product(s).

   Luben

