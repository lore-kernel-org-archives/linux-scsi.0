From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 12:24:55 +0100
Message-ID: <20090304112455.GB14593@elte.hu>
References: <20090303192212.GA20705@elte.hu> <1236115544.15993.22.camel@localhost.localdomain> <20090303214454.GA8288@elte.hu> <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:39396 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbZCDLZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 06:25:13 -0500
Content-Disposition: inline
In-Reply-To: <49AE32B5.9040603@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Mike Galbraith <efault@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Mike Galbraith wrote:
> > On Wed, 2009-03-04 at 07:39 +0100, Stefan Richter wrote:
> >> Ingo Molnar wrote:
> >>> Yeah, these commits are in none of the topic branches that are=20
> >>> the git base of development, they are all already in a separate=20
> >>> branch named "tip:out-of-tree".
> >> So people should remember to retry without out-of-tree before repo=
rting
> >> problems =3D=3D remember to report against the development base.
> >=20
> > I'll bite, how does a gut-fu white belt accomplish that?
>=20
> How to do it is currently not quite obvious
>   - for linux-2.6-x86.git users because the master branch contains
>     out-of-tree.=B9  Or maybe nobody should use the master branch,
>     I don't know.
>   - Ditto for linux-2.6.tip.git.=B2
> It was also impossible for users of the -rt patchset because the faul=
ty
> patch was obviously included in a base patch in the -rt patch series.=
=B3

Dont be silly. Have you never seen a faulty v1 fix patch in -mm=20
or any of the other dozens of generic trees, replaced by a=20
better working v2 patch in the next release?

=46YI, we still have not tracked down the SCSI bug. Latest=20
tip:master is able to boot and work on the affected systems,=20
while the upstream kernel does not even boot because the fix (or=20
the revert, should the fix be deemed unwanted) is stuck in the=20
SCSI tree.

But even with all known SCSI fixes applied there's still a crash=20
in the SCSI code that Thomas can trigger - reproduced on=20
mainline as well.

Instead of spreading advice in this thread about how to run a=20
high-volume generic tree [which you've never done before] you=20
could also have used your time to look at the crashes that were=20
posted, and you could have helped us fix the bug ;-)

	Ingo
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
