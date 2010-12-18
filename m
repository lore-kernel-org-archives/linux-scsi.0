From: chetan loke <loke.chetan@gmail.com>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc6 for 2.6.37-rc6
Date: Sat, 18 Dec 2010 13:57:23 -0500
Message-ID: <AANLkTi=pZirg0E-1vXNDSDT6sSTBb626kbuBuzw_9=o7@mail.gmail.com>
References: <1292557664.31461.68.camel@haakon2.linux-iscsi.org>
	<1292599364.2820.21.camel@mulgrave.site>
	<4D0B8975.1040206@vlnb.net>
	<1292602908.2820.41.camel@mulgrave.site>
	<4D0BBE40.6030000@vlnb.net>
	<1292617658.2820.80.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f66.google.com ([209.85.161.66]:62881 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932069Ab0LRS5Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Dec 2010 13:57:25 -0500
In-Reply-To: <1292617658.2820.80.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, "Patil, Kiran" <kiran.patil@intel.com>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Joe Eykholt <jeykholt@cisco.com>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Bart Van Assche <bart.vanassche@gmail.com>

On Fri, Dec 17, 2010 at 3:27 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
>
> > =A0Obviously,
> > this is wrong. No doubts, that all what Linux kernel can do with th=
e
> > same quality as it does can be added to the student's kernel sooner=
 or
> > later, ... but after several decades of hard work of thousands of p=
eople.
>
> Precisely. =A0Or said a different way: as long as you choose the most
> community oriented of competing offerings, the community will fill an=
y
> perceived gaps. =A0Conversely, you can destroy a project simply by
> alienating the community. =A0That's why community is more important t=
han
> feature set.
>

Your definition of community encompasses just the lead developers and
not average developers. This ain't right. If community is more
important then SCST should at least be heard before leaning towards
LIO.

It was decided a year ago to merge LIO without sending any emails on
LKML or linux-scsi. I've mentioned this repeatedly and you've been
conveniently ignoring this fact.

> > Moreover, isn't Linux kernel and you as a maintainer supposed to ch=
oose
> > what is ALREADY the best, not what is promising to become better
> > somewhen in the future? Or not become.
>
> No, see above. =A0Many technically very competent potential additions=
 to
> linux have failed because of maintainer problems.
>

And what maintainer problems is SCST posing to the linux community??
You clearly distorted the facts during linux-con 2010 when I asked you
about SCST. You said 'SCST cannot be integrated because Vlad is not
comfortable relinquishing control of SCST'. It's GPL'd code. What
control were you talking about?

> > > This isn't a democracy ... it's about choosing the most community
> > > oriented code base so that it's easily maintainable and easy to a=
dd
> > > feature requests and improvements as and when they come along. =A0=
In the
> > > past six months, LIO has made genuine efforts to clean up its act=
,
> > > streamline its code and support the other community projects that=
 would
> > > need to go above and around it.
> >

Ok, so our request was simple. Let's have a review at the architecture
and block level rather than sending patch-emails.
Others seem to agree at this approach so why can't you take it as an
action item please? This way we can stop this email drama, no?


> > > You seem to have spent a lot of the
> > > intervening time arguing with the sysfs maintainer about why you'=
re
> > > right and he's wrong.
> >

Just for argument sake, if zero time was spent on discussing the sysfs
plane and if a patch was cut the next day you would have merged SCST?
Ok, so Bart sent the patch. Now what?


Chetan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
