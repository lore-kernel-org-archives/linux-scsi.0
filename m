From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 08:50:13 +0100
Message-ID: <49AE32B5.9040603@s5r6.in-berlin.de>
References: <49ACF8FE.2020904@panasas.com>	 <1236093718.3263.3.camel@localhost.localdomain>	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>	 <1236097526.3263.17.camel@localhost.localdomain>	 <20090303192212.GA20705@elte.hu>	 <1236115544.15993.22.camel@localhost.localdomain>	 <20090303214454.GA8288@elte.hu>	 <1236119990.24019.35.camel@localhost.localdomain>	 <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>	 <20090303234834.GA13389@elte.hu>  <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <1236150752.6049.19.camel@marge.simson.net>
Sender: linux-rt-users-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

Mike Galbraith wrote:
> On Wed, 2009-03-04 at 07:39 +0100, Stefan Richter wrote:
>> Ingo Molnar wrote:
>>> Yeah, these commits are in none of the topic branches that are=20
>>> the git base of development, they are all already in a separate=20
>>> branch named "tip:out-of-tree".
>> So people should remember to retry without out-of-tree before report=
ing
>> problems =3D=3D remember to report against the development base.
>=20
> I'll bite, how does a gut-fu white belt accomplish that?

How to do it is currently not quite obvious
  - for linux-2.6-x86.git users because the master branch contains
    out-of-tree.=B9  Or maybe nobody should use the master branch,
    I don't know.
  - Ditto for linux-2.6.tip.git.=B2
It was also impossible for users of the -rt patchset because the faulty
patch was obviously included in a base patch in the -rt patch series.=B3

As I said, I recommend that people do not receive those off-topic
patches by default, only on demand.  (Because I sometimes work with -rt
users.)

=B9)http://git.kernel.org/?p=3Dlinux/kernel/git/mingo/linux-2.6-x86.git=
;a=3Dcommit;h=3D4239438b08fe8ec149ddc530238ca131bf88d290
=B2)http://git.kernel.org/?p=3Dlinux/kernel/git/tip/linux-2.6-tip.git;a=
=3Dcommit;h=3D4239438b08fe8ec149ddc530238ca131bf88d290
=B3)http://lkml.org/lkml/2009/3/3/424
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--=3D --=3D=3D --=3D--
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
