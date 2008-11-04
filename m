From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH 03/18] libosd: OSDv1 Headers
Date: Tue, 4 Nov 2008 21:29:09 +0100
Message-ID: <20081104202909.GE16036@logfs.org>
References: <491073BB.4000900@panasas.com> <1225817046-5946-1-git-send-email-bharrosh@panasas.com> <20081104111037.bcae04e5.akpm@linux-foundation.org> <20081104194240.GC16036@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756155AbYKDU3t@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081104194240.GC16036@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu, fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com
List-Id: linux-scsi@vger.kernel.org

On Tue, 4 November 2008 20:42:40 +0100, J=C3=B6rn Engel wrote:
> On Tue, 4 November 2008 11:10:37 -0800, Andrew Morton wrote:
> >=20
> > etc, etc, etc.   Please review all that.
>=20
> One easy way to review 98% is to include the header in an otherwise
> empty foo.c and compile that.  The remaining 2% are hidden behind
> different config options and architectures.  Although your header may=
 be
> fine on that front.

Btw, running such a script on include/linux detects a lot of trouble
even with i386 allnoconfig.  Most of which looks it could be 'fixed' by
a drunken monkey inserting #includes.  But some of those #includes may
be fs.h and pull the kitchensink, adding tons of dependencies and some
compile time.

Unsure.

J=C3=B6rn

--=20
Rules of Optimization:
Rule 1: Don't do it.
Rule 2 (for experts only): Don't do it yet.
-- M.A. Jackson
