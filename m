From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: targetcli -fb now also Apache 2.0 licensed
Date: Wed, 24 Jul 2013 13:54:49 -0700
Message-ID: <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>
References: <51EF73EF.1040305@redhat.com>
	 <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>
	 <1374697264.7382.39.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1374697264.7382.39.camel@dabdike>
Sender: target-devel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andy Grover <agrover@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ritesh Raj Sarraf <rrs@debian.org>, targetcli-fb-devel@lists.fedorahosted.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-07-24 at 13:21 -0700, James Bottomley wrote:
> On Wed, 2013-07-24 at 13:09 -0700, Nicholas A. Bellinger wrote:
> > On Tue, 2013-07-23 at 23:27 -0700, Andy Grover wrote:
> > > Hi Nick,
> > > 
> > > I just wanted to let you know that I finally received permission from 
> > > all contributors, and have matched RisingTide's relicensing of targetcli 
> > > and its dependencies to Apache 2.0, by relicensing the additional 
> > > contributions in the targetcli-fb branch under the same license.
> > > 
> > > I'm not quite sure the next steps are, except enjoying all our newly 
> > > non-viral source code, but much thanks for getting the ball rolling.
> > > 
> > 
> > Making this type of announcement without coordinating with us on a plan
> > for moving forward is pretty lame.  Especially considering that we've
> > kept asking you privately about how to work together to reconcile -fb
> > with upstream, and your response essentially boiled down to "What's in
> > it for me..?".
> 
> Oh good grief, children, how about you both play nicely in the sand box
> or I'll fetch your parents to make you see sense.
> 
> > So if you really, really need an incentive to "do the right thing", how
> > about I start not accept kernel patches from you until you're ready to
> > drop -fb and start working with upstream for real..?
> 
> Well, the thing is, being a maintainer in Linux is a position of trust.
> The fastest way to lose that trust is to hold your tree to ransom or
> indeed refuse to accept patches for anything other than technical or
> licensing reasons.

Yes, which is why I've been accepting his kernel patches the entire time
that user-space has been forked into -fb.  Now that the user-space code
has been relicensed as promised, there is no longer any reason for a
separate -fb fork to exist.

That said, it's time to start moving forward toward a single set of
source trees for upstream userspace, so that all distributions can
mutually benefit from the effort.  As mentioned above, this has so far
not been enough to get -fb reconciled with upstream.

So I don't consider the above 'holding for ransom' or any nonsense like
that, considering the end goal is for everyone (not just Fedora) to
benefit from -fb.

--nab
