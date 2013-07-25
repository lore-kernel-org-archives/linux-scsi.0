From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: targetcli -fb now also Apache 2.0 licensed
Date: Wed, 24 Jul 2013 18:19:00 -0700
Message-ID: <1374715140.7397.1390.camel@haakon3.risingtidesystems.com>
References: <51EF73EF.1040305@redhat.com>
	 <1374696565.7397.1292.camel@haakon3.risingtidesystems.com>
	 <1374697264.7382.39.camel@dabdike>
	 <1374699289.7397.1309.camel@haakon3.risingtidesystems.com>
	 <51F06C17.50306@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <51F06C17.50306@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Ritesh Raj Sarraf <rrs@debian.org>, targetcli-fb-devel@lists.fedorahosted.org, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2013-07-24 at 17:06 -0700, Andy Grover wrote:
> On 07/24/2013 01:54 PM, Nicholas A. Bellinger wrote:
> > Yes, which is why I've been accepting his kernel patches the entire time
> > that user-space has been forked into -fb.  Now that the user-space code
> > has been relicensed as promised, there is no longer any reason for a
> > separate -fb fork to exist.
> >
> > That said, it's time to start moving forward toward a single set of
> > source trees for upstream userspace, so that all distributions can
> > mutually benefit from the effort.  As mentioned above, this has so far
> > not been enough to get -fb reconciled with upstream.
> >
> > So I don't consider the above 'holding for ransom' or any nonsense like
> > that, considering the end goal is for everyone (not just Fedora) to
> > benefit from -fb.
> 
> There's nothing stopping any other distro (or commercial entity) from 
> adopting targetcli-fb. I don't know why they haven't, except that 
> there's a default attitude that the originator of the project is the 
> "upstream" forever.

Please stop trying to drive the split wider, and attempting to make
yourself upstream for something that you did not create.

You are responsible for this fork (and associated headaches) to begin
with.  Now that we have, as promised, relicensed this code, the time has
come to do the right thing for the wider community and push your changes
upstream.

Please read the following:

https://fedoraproject.org/wiki/Staying_close_to_upstream_projects

"The Fedora Project focuses, as much as possible, on not deviating from
upstream in the software it includes in the repository."

Don't you think this applies to you, too?

> 
> I think I've done a pretty good job maintaining -fb over the past two 
> years -- -fb has bug tracking, a list, tarballs, and is actively 
> maintained and improved, all things that are not true of upstream.
> 
> My question to you (Nick) is, why don't we all just unify on -fb?
> 

Because -fb has had close to zero peer review, and you've not solicited
much input (none from us) before making significant changes to
rtslib/targetcli over the past 1 1/2 years.

For your own private tree this wouldn't matter.  However, for a single
upstream tree moving forward, it seems irresponsible to just ask us to
sign off on every decision that you've made in -fb with little external
review or input.

So, to help us get back to a community development model, please cut a
-fb branch against upstream rtslib/configshell/targetcli, and start
sending the series out for public review.

--nab
