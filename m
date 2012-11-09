From: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
Subject: Re: scsi target, likely GPL violation
Date: Thu, 08 Nov 2012 18:08:16 -0800
Message-ID: <1352426896.29589.512.camel@haakon2.linux-iscsi.org>
References: <509A915B.30105@redhat.com>
	 <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>
	 <509B117A.6070708@genband.com>  <509BE460.6010404@redhat.com>
	 <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
	 <509C22B2.8010600@redhat.com>
Reply-To: nab@risingtidesystems.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <509C22B2.8010600@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-11-08 at 13:22 -0800, Andy Grover wrote:
> On 11/08/2012 12:05 PM, Nicholas A. Bellinger wrote:
> > Accusing us of violating GPL is a serious legal claim. =20
> >=20
> > In fact, we are not violating GPL.  In short, this is because we wr=
ote
> > the code you are referring to (the SCSI target core in our commerci=
al
> > RTS OS product), we have exclusive copyright ownership of it, and t=
his
> > code contains no GPL code from the community.  GPL obligations only
> > apply downstream to licensees, and not to the author of the code.  =
Those
> > who use the code under GPL are subject to its conditions; we are no=
t.
>=20
> Hi Nick, thanks for finally responding.
>=20
> I believe your argument is wrong for two reasons.
>=20
> First, LIO is a derivative work of the Linux kernel. It uses kernel A=
PIs
> and headers. You ship Linux as part of RTS OS. Even if you had not as=
ked
> for LIO to be included in mainline, this would still be true and woul=
d
> require you to publish your changes under the GPLv2.
>=20
> Second, you claim you hold exclusive copyright for the code. Not true=
=2E
> One example: on http://www.risingtidesystems.com/storage.html you cla=
im
> support for FCoE. You didn't build tcm_fc, Intel did. Under the GPLv2=
=2E
> Furthermore, SRP support came from SCST, iirc. None of these
> contributors gave RTS any right to use their copyrighted code except
> under the conditions of the GPLv2.
>=20

Andy,

Support for certified VAAI is part of our commercial target core. The
target core constitutes a stand-alone kernel subsystem of which we are
the sole copyright owners. In addition, our target contains a number of
backend drivers, of which we are also the sole copyright owners, and a
number of fabric modules, of which some we are the sole copyright
owners, and of which others we are not, as you pointed out. A
substantial fraction of the code of which we own the sole copyright was
certified by BlackDuck Software as early as in 2007.=20

We contributed our target to the Linux kernel in 2010, at which point w=
e
forked it into the upstream version and our commercial version. These
target versions have been diverging over time, as we keep maintaining
either one of them independently.

=46or our commercial target core, we only use Linux kernel symbols that
are not marked as GPL. In addition, we define the API between the targe=
t
core and its backend drivers and between the target core and its fabric
modules, we define the ABI between the target core and user space, and
we have done so years before our code went upstream into the Linux
kernel.

We have been contributing substantially to the upstream target version
to keep improving Linux. We have also been improving our commercial
target version to afford the considerable effort and expense involved i=
n
our ongoing Linux contributions, and to compensate other top Linux
kernel developers for their contributions to the upstream target
version.

RTS OS is based on a stock Linux enterprise kernel. This Linux kernel
has naturally the ability to load either one of our standalone
self-contained target module versions without any modifications.

Again, we=E2=80=99re very disappointed by these untrue and highly damag=
ing
accusations from Red Hat. We have generously contributed to Linux, and
we have generously supported the Linux community for their contribution=
s
to our upstream target and other Linux kernel parts. You have mostly
just incorporated our work into Red Hat=E2=80=99s products.

So yes, Andy, please start behaving properly, so that at least we can
get back to making Linux better.

--nab
