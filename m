From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conformity.
Date: Fri, 28 Mar 2014 00:01:40 -0500
Message-ID: <201403280501.s2S51eC7027504@wind.enjellic.com>
References: <tommyapeldk@gmail.com>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:34130 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbaC1FBv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 01:01:51 -0400
In-Reply-To: Tommy Apel <tommyapeldk@gmail.com>
       "Re: [Scst-devel] OSS target - VMware SCSI reservation bug conformity." (Mar 27,  9:22pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tommy Apel <tommyapeldk@gmail.com>
Cc: scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Mar 27,  9:22pm, Tommy Apel wrote:
} Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conform

Good morning, hope the end of the week is going well for everyone.

> 2014-03-27 19:21 GMT+01:00 Dr. Greg Wettstein <greg@wind.enjellic.com>:
> > Hi, hope the week is going well for everyone.
> >
> > There appears to be evidence that VMware has an issue with exact SCSI
> > standards compliance when it comes to handling corner cases with SCSI
> > reservation requests.  It appears as if Dell is pushing firmware hot
> > fixes for the EqualLogic controllers to work around the issue.

> Hello lists, excuse me for being a little blunt here, but if what
> Dr.  Greg is telling here is correct, shouldn't it be vmware that
> fixed their BUG in their software rather that everybody else asking
> "how high" when vmware says jump ?
>
> I mean, implementing non-standard things to a standard compliant
> stack is sort of the wrong path to take I should think, the fact
> that vmware has a but in their software, closed source I might add,
> they should fix it not the OSS community.
>
> Maybe I'm wrong here, but I believe that standards were made so that
> everybody could implement a look-the-same / feel-the-same interface
> instead of inventing the wheel over and over again for every brand
> known to man kind.

Very understandable sentiments and ones which I certainly sympathize
with.

I've been doing this stuff for a long time and unfortunately I believe
this is a situation where the old meme applies:

	"The wonderful thing about standards is that there are so many
	 to choose from."

I would add to that:

	"Everyone should have their own version of their favorite
	 standard."

Every standard ever written has issues with respect to behavior on
edge cases.  I believe VMware's position is that it has implemented
the standard properly and if there is a bug it isn't their issue.

If there is an issue it is obviously an edge case given that it
appears to be quite rare.  I've heard suggestions that the possible
vulnerability window amounts to about 12 seconds a day.

Whatever the reality of the regression, given the litiginous nature of
our society I think it is highly unlikely for anyone to admit they
have a bug in terms of standards implementation, particularly in the
storage industry.  To do so would open one to inevitable data loss
litigation.

I'm not a fan of 'tuning' standards implemenations but mode pages seem
to be a reality in the industry and there are ample practical reasons
for them.  The other reality is that VMware/EMC is a way bigger
gorilla then the open-source storage stacks whether they be LIO, SCST
or anything else.

If there is an issue it would seem to be in the best interests of
those of us committed to open-source storage solutions to understand
and protect ourselves from the situation.  There is a third saying
which is important as well:

	"No one ever got fired for buying vendor approved storage."

> /Tommy

Have a good weekend.

Greg

}-- End of excerpt from Tommy Apel

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"God made man, the appendix was the result of a committee."
                                -- Dr. G.W. Wettstein
                                   Guerrilla Tactics for Corporate Survival
