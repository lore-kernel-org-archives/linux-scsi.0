From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Sun, 22 Apr 2012 18:13:29 -0400
Message-ID: <20120422221329.GB24109@redhat.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120421001433.2955abd4@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Apr 20 2012 at  7:14pm -0400,
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> There is no "Linux only" magic in _GPL. Any derivative work of a GPL work
> must be distributed under the GPL.

The author and maintainers of the scsi_dh code agreed that relaxing
scsi_dh_detach's export was fine and they acked the change.  Their
rights are important too.

And I understand what you're saying about you and others being rights
holders that have a say.  But communication has broken down because
you've been unwilling to concede that those who have acked this
relaxation _know_ that what scsi_dh provides is _not_ unique
functionality to Linux or Linux SCSI multipathing.

Allowing a proprietary driver to use scsi_dh_detach to unload scsh_dh*'s
associated additional SCSI sense and error processing doesn't implicitly
mean said driver is using derived work to achieve it's comparable
processing.  It simply means their offering reasonably conflicts with
what Linux is providing:

All SCSI multipathing drivers are expected to interpret and react to
SCSI sense information.  Doing so is not an innovation unique to Linux.
Because it is not unique it collides with a long established proprietary
driver's offering.

> > You still don't get it... yet you'll saber rattle behind generic GPL
> > lawyer-up nonsense.
> 
> This has gone far enough but it seems your management has already jumped
> on it. Not my preferred way of handling such matters but Red Hat legal and
> PR need to rein you in before you cause some serious damage.

Yes, secretly switching channels to google+ and lobbing questions about
Red Hat's commitment to free software at one of Red Hat's OSS community
leaders probably isn't the preferred way to handle such things.

But seeing a s/EXPORT_SYMBOL_GPL/EXPORT_SYMBOL/ change clearly does
trigger a negative reaction for some (and that really doesn't make them
"zealots").  However the validity of making that change should not be so
easily stifled with rhetorical GPL violation theory or legal threat.  I
don't respond well to threats but could have certainly used more tact in
my original responses to you.

You capture the hearts and minds of many Linux and GPL stakeholders and
are well respected -- and believe it or not I'm not some naive or
reckless individual.  I am a professional Linux developer who works for
the most respected name in Open Source development.

And I now do _not_ have concerns of legal issues associated with this
change.  I genuinely do appreciate your concern though.

You view this change as detrimental to Linux and think it could
theoretically be enabling proprietary use of derived work.  Reasonable
initial concern but this change does not do that for the intended use --
as hard as it may be to believe it actually benefits Linux multipathing.
And as I said on google+:

"I've been very pragmatic with my reasoning behind this change and
followed the established process of getting author and maintainer
buy-off.  None of us are out to hurt Linux."

With that said, I'm leaving the decision of whether or not to relax
scsi_dh_detach's export in the very capable hands of James Bottomley.

I'll be fine with whatever James decides but do hope that this outcry
will not serve to establish precedent that ties our hands in the future
when comparable decisions need to be made about the improvement of
Linux's interfaces and overall function.

Regards,
Mike
