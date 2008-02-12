From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 12 Feb 2008 13:28:15 -0600
Message-ID: <1202844495.3137.120.camel@localhost.localdomain>
References: <1202172065.3096.154.camel@localhost.localdomain>
	 <922945.25870.qm@web31811.mail.mud.yahoo.com>
	 <20080212102244.32869382@appleyard>
	 <1202841935.3137.94.camel@localhost.localdomain>
	 <20080212110752.21840627@appleyard>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20080212110752.21840627@appleyard>
Sender: linux-ide-owner@vger.kernel.org
To: kristen.c.accardi@intel.com
Cc: ltuikov@yahoo.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, jeff@garzik.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2008-02-12 at 11:07 -0800, Kristen Carlson Accardi wrote:
> I understand what you are trying to do - I guess I just doubt the value
> you've added by doing this.  I think that there's going to be so much
> customization that system vendors will want to add, that they are going
> to wind up adding a custom library regardless, so standardising those
> few things won't buy us anything.

It depends ... if you actually have a use for the customisations, yes.
If you just want the basics of who (what's in the enclousure), what
(activity) and where (locate) then I think it solves your problem almost
entirely.

So, entirely as a straw horse, tell me what else your enclosures provide
that I haven't listed in the four points.  The SES standards too provide
a huge range of things that no-one ever seems to implement (temperature,
power, fan speeds etc).

I think the users of enclosures fall int these categories

85% just want to know where their device actually is (i.e. that sdc is
in enclosure slot 5)
50% like watching the activity lights
30% want to be able to have a visual locate function
20% want a visual failure indication (the other 80% rely on some OS
notification instead)

When you add up the overlapping needs, you get about 90% of people happy
with the basics that the enclosure services provide.  Could there be
more ... sure; should there be more ... I don't think so ... that's what
value add the user libraries can provide.

James


