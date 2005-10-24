From: "Regala" <matt@regala.cx>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally	attached PHYs)
Date: Mon, 24 Oct 2005 16:04:36 +0000 (UTC)
Message-ID: <87vezm7vox.fsf__35255.826477851$1130169876$gmane$org@barad-dur.minas-morgul.org>
References: <4359440E.2050702@pobox.com> <43595275.1000308@adaptec.com>
	<435959BE.5040101@pobox.com> <43595CA6.9010802@adaptec.com>
	<43596070.3090902@pobox.com> <43596859.3020801@adaptec.com>
	<43596F16.7000606@pobox.com> <435A1793.1050805@s5r6.in-berlin.de>
	<20051022105815.GB3027@infradead.org>
	<1129994910.6286.21.camel@sipan.sipan.org>
	<20051022171943.GA7546@infradead.org> <435CE6CA.4070704@adaptec.com>
	<1130168495.12873.27.camel@localhost.localdomain>
	<435CFA5A.2030104@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751121AbVJXP7O@vger.kernel.org>
Date: lun, 24 oct 2005 17:59:10 +0200
In-Reply-To: <435CFA5A.2030104@adaptec.com> (Luben Tuikov's message of "Mon,
	24 Oct 2005 11:14:34 -0400")
Sender: linux-kernel-owner@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>, Sergey Panov <sipan@sipan.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

Luben Tuikov <luben_tuikov@adaptec.com> disait derni=E8rement que :

> On 10/24/05 11:41, Alan Cox wrote:
>> On Llu, 2005-10-24 at 09:51 -0400, Luben Tuikov wrote:
>>=20
>>>controls and how.  Understanding how the factory workers use it and =
what
>>>they expect.  Understanding the code (which may not be as easy).  Th=
en it
>>>is rewritten so that it can be easily supported and maintained.
>>=20
>>=20
>> Very very rarely, because it means down time and supporting two syst=
ems
>> at once. Take a look at the australian customs fiasco or the british
>> passport office disaster to see why (actually almost any large
>> government IT project where politics dictated 'write new stuff so I =
can
>> announce it in parliament').
>>=20
>> The smart factory update would occur piece by piece. Starting with t=
he
>> most pressing problems (ie fastest ROI) and working to a plan that e=
nds
>> up with the system modular and clean.
>>=20
>> You don't turn a steel plant off for a software upgrade.
>
> There was 0 (zero) effective downtime to the factory.

but refactoring can be done in incremental pieces, can't be ?
rewriting it from scratch is, in this very case, really for the sake
of self-pride and brain-masturbation.
Bravo

This is not a really convincing example...

--=20
Mathieu Segaud
