From: Andy Grover <agrover@redhat.com>
Subject: Re: scsi target, likely GPL violation
Date: Thu, 08 Nov 2012 13:22:58 -0800
Message-ID: <509C22B2.8010600@redhat.com>
References: <509A915B.30105@redhat.com>  <CAPoiz9wzx_NmuA1ty-U28MGiYr7XKCbDn_e0ZLmz=pNDCqwqFw@mail.gmail.com>  <509B117A.6070708@genband.com>  <509BE460.6010404@redhat.com> <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1352405111.29589.476.camel@haakon2.linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Chris Friesen <chris.friesen@genband.com>, Jon Mason <jdmason@kudzu.us>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Marc Fleischmann <mwf@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On 11/08/2012 12:05 PM, Nicholas A. Bellinger wrote:
> Accusing us of violating GPL is a serious legal claim. =20
>=20
> In fact, we are not violating GPL.  In short, this is because we wrot=
e
> the code you are referring to (the SCSI target core in our commercial
> RTS OS product), we have exclusive copyright ownership of it, and thi=
s
> code contains no GPL code from the community.  GPL obligations only
> apply downstream to licensees, and not to the author of the code.  Th=
ose
> who use the code under GPL are subject to its conditions; we are not.

Hi Nick, thanks for finally responding.

I believe your argument is wrong for two reasons.

=46irst, LIO is a derivative work of the Linux kernel. It uses kernel A=
PIs
and headers. You ship Linux as part of RTS OS. Even if you had not aske=
d
for LIO to be included in mainline, this would still be true and would
require you to publish your changes under the GPLv2.

Second, you claim you hold exclusive copyright for the code. Not true.
One example: on http://www.risingtidesystems.com/storage.html you claim
support for FCoE. You didn't build tcm_fc, Intel did. Under the GPLv2.
=46urthermore, SRP support came from SCST, iirc. None of these
contributors gave RTS any right to use their copyrighted code except
under the conditions of the GPLv2.

> As you know, we contributed the Linux SCSI target core, including the
> relevant interfaces, to the Linux kernel.  To be clear, we wrote that
> code entirely ourselves, so we have the right to use it as we please.
> The version we use in RTS OS is a different, proprietary version, whi=
ch
> we also wrote ourselves.  However, the fact that we contributed a
> version of the code to the Linux kernel does not require us to provid=
e
> our proprietary version to anyone.

In addition to the two reasons above, how does it make any sense that
you are spending time maintaining in-tree LIO when none of that code ca=
n
theoretically benefit RTS's proprietary product? The more likely
scenario is you are basing your product on mainline LIO.

> If you want to understand better how dual licensing works, perhaps we
> can talk off list.  But we don=E2=80=99t really have a responsibility=
 to respond
> to untrue accusations, nor to explain GPL, nor discuss our proprietar=
y
> code.

All the contributions and improvements (there have been a LOT) since LI=
O
entered mainline are GPLed by their authors. If you incorporated any of
those improvements or fixes into RTS OS, then there's a third reason wh=
y
your code is subject to the GPL.

> We=E2=80=99re very disappointed that Red Hat would not be more profes=
sional in
> its communications about licensing compliance matters, particularly t=
o a
> company like ours that has been a major contributor to Linux and
> therefore also to Red Hat=E2=80=99s own products.  So, while I invite=
 you to
> talk about this with us directly, I also advise you =E2=80=93 respect=
fully =E2=80=93 not
> to make public accusations that are not true.  That is harmful to our
> reputation =E2=80=93 and candidly, it doesn=E2=80=99t reflect well on=
 you or your
> company.

I tried the private route but you and your CEO stalled, and then stoppe=
d
talking to me.

Please just start behaving properly w/r/t the GPL so we can all get bac=
k
to coding.

Regards -- Andy
