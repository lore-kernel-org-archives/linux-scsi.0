From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 09:30:39 -0700
Message-ID: <76417E04-4E3A-4064-A936-CEF12A8B674E@yahoo.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Mime-Version: 1.0 (iPhone Mail 8J2)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
Cc: James Bottomley <jbottomley@parallels.com>, "<linux-scsi@vger.kernel.org>" <linux-scsi@vger.kernel.org>, "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>, Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

Isn't this my own patch? Shouldn't have I regenerated it and sent of of=
f? Is it common here to have other people generate other people's patch=
es? I think that not very professional.=20

James, you should apply the patch I'm about to send. Same one, tabs fix=
ed.=20

        Luben


On Sep 22, 2011, at 8:04, "Mark Salyzyn" <mark_salyzyn@us.xyratex.com> =
wrote:

> Enclosed is an updated patch that passes checkpatch.pl (a few 80-char=
acter line errors in the original), maintain existing indent mechanics =
and contains my 'Ack' and the recommended Cc list.
>=20
> Wait for Luben's Ack or Override (despite the fact I took the liberty=
 of adding his Signed-off-by on the checkpatch required adjustments).
>=20
> Sincerely -- Mark Salyzyn=20
>=20
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of James Bottomley
> Sent: Thursday, September 22, 2011 7:30 AM
> To: Luben Tuikov
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
>=20
> On Wed, 2011-07-27 at 21:19 -0700, Luben Tuikov wrote:
>> Allow expander table-to-table attachments for
>> expanders that support it.
>>=20
>> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>=20
> OK, so now I need an applyable patch, please.  It looks like the mail
> server has mapped all tabs to spaces.  If you can't fix the mailer, j=
ust
> sending the patch as an attachment is fine.
>=20
> James
>=20
> NrybX=C7=A7v^)=DE=BA{.n+{"{ay=1D=CA=87=DA=99,j fhz=1Ew=0Cj:+vwjm zZ+=DD=
=A2j"!
>=20
> _____________________________________________________________________=
_
> This email may contain privileged or confidential information, which =
should only be used for the purpose for which it was sent by Xyratex. N=
o further rights or licenses are granted to use such information. If yo=
u are not the intended recipient of this message, please notify the sen=
der by return and delete it. You may not use, copy, disclose or rely on=
 the information contained in it.
>=20
> Internet email is susceptible to data corruption, interception and un=
authorised amendment for which Xyratex does not accept liability. While=
 we have taken reasonable precautions to ensure that this email is free=
 of viruses, Xyratex does not accept liability for the presence of any =
computer viruses in this email, nor for any losses caused as a result o=
f viruses.
>=20
> Xyratex Technology Limited (03134912), Registered in England & Wales,=
 Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>=20
> The Xyratex group of companies also includes, Xyratex Ltd, registered=
 in Bermuda, Xyratex International Inc, registered in California, Xyrat=
ex (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi)=
 Co Ltd registered in The People's Republic of China and Xyratex Japan =
Limited registered in Japan.
> _____________________________________________________________________=
_
>=20
>=20
> <libsas_t2t.patch>
