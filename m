From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
Date: Thu, 22 Sep 2011 09:35:19 -0700 (PDT)
Message-ID: <1316709319.79868.YahooMailNeo@web31804.mail.mud.yahoo.com>
References: <1311826792.28583.YahooMailNeo@web31811.mail.mud.yahoo.com> <1316691000.10571.6.camel@dabdike> <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018AE2C6@XYUS-EX22.xyus.xyratex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, James Bottomley <jbottomley@parallels.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Darrick Wong <djwong@us.ibm.com>, Xiangliang Yu <yuxiangl@marvell.com>, Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

Salyzyn, DON'T do this any more with mine or anybody else's patches. OK=
AY?



----- Original Message -----
> From: Mark Salyzyn <mark_salyzyn@us.xyratex.com>
> To: James Bottomley <jbottomley@parallels.com>; Luben Tuikov <ltuikov=
@yahoo.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Darrick=
 Wong <djwong@us.ibm.com>; Xiangliang Yu <yuxiangl@marvell.com>; Jack W=
ang <jack_wang@usish.com>
> Sent: Thursday, September 22, 2011 8:04 AM
> Subject: RE: [PATCH] [SCSI] libsas: Allow expander T-T attachments
>=20
> Enclosed is an updated patch that passes checkpatch.pl (a few 80-char=
acter line=20
> errors in the original), maintain existing indent mechanics and conta=
ins my=20
> 'Ack' and the recommended Cc list.
>=20
> Wait for Luben's Ack or Override (despite the fact I took the liberty=
 of=20
> adding his Signed-off-by on the checkpatch required adjustments).
>=20
> Sincerely -- Mark Salyzyn=20
>=20
> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org]=20
> On Behalf Of James Bottomley
> Sent: Thursday, September 22, 2011 7:30 AM
> To: Luben Tuikov
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] [SCSI] libsas: Allow expander T-T attachments
>=20
> On Wed, 2011-07-27 at 21:19 -0700, Luben Tuikov wrote:
>>  Allow expander table-to-table attachments for
>>  expanders that support it.
>>=20
>>  Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
>=20
> OK, so now I need an applyable patch, please.=C2=A0 It looks like the=
 mail
> server has mapped all tabs to spaces.=C2=A0 If you can't fix the mail=
er, just
> sending the patch as an attachment is fine.
>=20
> James
>=20
> NrybX=C7=A7v^)=DE=BA{.n+{"{ay=CA=87=DA=99,j fhzwj:+vwjm zZ+=DD=A2j"!
>=20
> _____________________________________________________________________=
_
> This email may contain privileged or confidential information, which =
should only=20
> be used for the purpose for which it was sent by Xyratex. No further =
rights or=20
> licenses are granted to use such information. If you are not the inte=
nded=20
> recipient of this message, please notify the sender by return and del=
ete it. You=20
> may not use, copy, disclose or rely on the information contained in i=
t.
>=20
> Internet email is susceptible to data corruption, interception and un=
authorised=20
> amendment for which Xyratex does not accept liability. While we have =
taken=20
> reasonable precautions to ensure that this email is free of viruses, =
Xyratex=20
> does not accept liability for the presence of any computer viruses in=
 this=20
> email, nor for any losses caused as a result of viruses.
>=20
> Xyratex Technology Limited (03134912), Registered in England & Wales,=
=20
> Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>=20
> The Xyratex group of companies also includes, Xyratex Ltd, registered=
 in=20
> Bermuda, Xyratex International Inc, registered in California, Xyratex=
 (Malaysia)=20
> Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) Co Ltd regi=
stered in=20
> The People's Republic of China and Xyratex Japan Limited registered i=
n=20
> Japan.
> _____________________________________________________________________=
_
>
