From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Sun, 22 Apr 2012 23:34:54 +0100
Message-ID: <20120422233454.7cdd0f35@pyramind.ukuu.org.uk>
References: <20111215214440.GA17677@redhat.com>
	<4EF039D5.5010201@suse.de>
	<20120405144721.GA18437@redhat.com>
	<20120420144538.GB8155@redhat.com>
	<20120420173405.GA8846@redhat.com>
	<20120420214120.159e2690@pyramind.ukuu.org.uk>
	<20120420215825.GA10406@redhat.com>
	<20120420232043.40ddc3c4@pyramind.ukuu.org.uk>
	<20120420225822.GA10769@redhat.com>
	<20120421001433.2955abd4@pyramind.ukuu.org.uk>
	<20120422221329.GB24109@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:42873 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab2DVWca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2012 18:32:30 -0400
In-Reply-To: <20120422221329.GB24109@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org

> The author and maintainers of the scsi_dh code agreed that relaxing
> scsi_dh_detach's export was fine and they acked the change.  Their
> rights are important too.

They can only grant rights beyond the GPL providing they remove everyone
elses code. But that isn't the big issue. I wish you'd go talk to your
legal team, then you might understand the real problem here. But you
won't, so I'll hopefully be talking to them tomorrow.

> And I understand what you're saying about you and others being rights
> holders that have a say.  But communication has broken down because
> you've been unwilling to concede that those who have acked this
> relaxation _know_ that what scsi_dh provides is _not_ unique
> functionality to Linux or Linux SCSI multipathing.

"Unwilling to concede". There is nothing to concede. The GPL spells out
the rules. Also if you'd have talked to Red Hat legal you'd have
understood there are other issues here.

> Allowing a proprietary driver to use scsi_dh_detach to unload scsh_dh*'s
> associated additional SCSI sense and error processing doesn't implicitly
> mean said driver is using derived work to achieve it's comparable
> processing.  It simply means their offering reasonably conflicts with
> what Linux is providing:

Can I suggest you don't make legal statements from a Red Hat address
without talking to your legal team. It's not a good idea and tends to get
people into trouble.

> All SCSI multipathing drivers are expected to interpret and react to
> SCSI sense information.  Doing so is not an innovation unique to Linux.
> Because it is not unique it collides with a long established proprietary
> driver's offering.

That's their problem. They chose not to play ball, and they are going to
have to run after us and sort their own mess out. They'll cope as they've
had a lot of practice at it.

> Yes, secretly switching channels to google+ and lobbing questions about
> Red Hat's commitment to free software at one of Red Hat's OSS community
> leaders probably isn't the preferred way to handle such things.

I didn't do anything secret. How is posting publically "secret". Also I
made very sure the people who needed to see it in Red Hat did, so they
can do something about it and rein you in. It's had the right effect and
it means the right folks in Red Hat can look at the issue itself.

> You capture the hearts and minds of many Linux and GPL stakeholders and
> are well respected -- and believe it or not I'm not some naive or
> reckless individual.  I am a professional Linux developer who works for
> the most respected name in Open Source development.

I spent ten years at Red Hat, I'd like them to keep that reputation which
is one of the reasons this bothers me a lot. The other being the legal
issues.

> And I now do _not_ have concerns of legal issues associated with this
> change.  I genuinely do appreciate your concern though.

Well that's for Red Hat management and legal to determine, unless you are
also a practicing IP lawyer as well ?

> With that said, I'm leaving the decision of whether or not to relax
> scsi_dh_detach's export in the very capable hands of James Bottomley.
> 
> I'll be fine with whatever James decides but do hope that this outcry
> will not serve to establish precedent that ties our hands in the future
> when comparable decisions need to be made about the improvement of
> Linux's interfaces and overall function.

This isn't tying your hands. There are two things which tie your hands
here - the GPL (intentionally) and certain properties of US law - which
I'll discuss with the appropriate Red Hat people in an appropriate forum.
You clearly are not that appropriate person.

Perhaps after that they can explain to you in the proper manner internally

- Why legal matters should be referred to lawyers for checking.
- Why your patch may raise a particularly nasty potential problem if it
  were merged

Alan
