From: Mike Galbraith <efault@gmx.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 09:00:40 +0100
Message-ID: <1236153640.6729.3.camel@marge.simson.net>
References: <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <20090303192212.GA20705@elte.hu>
	 <1236115544.15993.22.camel@localhost.localdomain>
	 <20090303214454.GA8288@elte.hu>
	 <1236119990.24019.35.camel@localhost.localdomain>
	 <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>
	 <20090303234834.GA13389@elte.hu>  <49AE221D.9010909@s5r6.in-berlin.de>
	 <1236150752.6049.19.camel@marge.simson.net>
	 <49AE32B5.9040603@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <49AE32B5.9040603@s5r6.in-berlin.de>
Sender: linux-rt-users-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-03-04 at 08:50 +0100, Stefan Richter wrote:
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
>     out-of-tree.=C2=B9  Or maybe nobody should use the master branch,
>     I don't know.

Ah, ok.  I thought there might be an un-merge incantation or whatnot.

(seems to have just been an oopsie anyway)

	-Mike

--
To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
