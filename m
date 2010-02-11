From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: MVSAS status
Date: Thu, 11 Feb 2010 13:55:40 -0500
Message-ID: <1265914540.13197.57.camel@mulgrave.site>
References: <loom.20100210T002935-813@post.gmane.org>
	 <73e903671002110150h3c4ae0dcq17625f6d9b545bf4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:56927 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab0BKSzs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Feb 2010 13:55:48 -0500
In-Reply-To: <73e903671002110150h3c4ae0dcq17625f6d9b545bf4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristleifur =?ISO-8859-1?Q?Da=F0ason?= <kristleifur@gmail.com>
Cc: Orion Poplawski <orion@cora.nwra.com>, linux-scsi@vger.kernel.org

On Thu, 2010-02-11 at 09:50 +0000, Kristleifur Da=C3=B0ason wrote:
> On Tue, Feb 9, 2010 at 11:32 PM, Orion Poplawski <orion@cora.nwra.com=
> wrote:
> >
> > What's the status of the MVSAS patches posted in November '09?  I'm=
 just trying
> > to get started with mvsas and running into the mvs_abort_task issue=
=2E  At least
> > one person has reported that stability improved, but it looks like =
there were
> > some other issues with the patches.  Any chance on seeing this in t=
he mainline
> > kernel soon?  Are there updated versions?  A git tree to pull from?
> >
>=20
> As far as I know, the patches from November were rejected because the
> patches themselves weren't solid enough - meaning there were some
> cross-references between each of the seven patches, things like that.
> The functionality was fine, at least a definite improvement. Ideally,
> there would have been another set of patches to top things up and
> really get everything running smoothly.

There were two reasons for the reject.  The first was that the series
just wasn't bisectable.  This is annoying but not completely fatal, and
if it were a required bug fix I can just squash all the patches togethe=
r
to apply to make a single commit.  I hate doing this but I've done it
before with problem vendor patch series.

The bigger problem was there were several reports of the rate of kernel
panics increasing with this patch series applied.  If the patch series
is going to decrease stability, it's not worth applying.

I can fix the first if someone can do a solid comparison and assure me
that the patch series does actually increase not decrease stability.

> I haven't come across any patch traffic for the card after that Novem=
ber batch.

Yes, Marvell has gone radio silent.

> In the interests of getting these amazingly cheap and effective cards
> running properly on Linux, it would be extremely good if someone
> experienced with Linux patches would get involved in the matter with
> Mr. Andy Yan from Marvell, straighten things out, get the ball rollin=
g
> and make the driver stick in mainline. When I emailed him, Mr. Yan wa=
s
> very helpful and sent me the patches and some info. I tried to fix th=
e
> patches myself but was in over my head. And had no time. Etc.

OK, I'll try 1:1 email with Marvell and Andy and see what comes out.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
