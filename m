From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [BUG?] GDTH driver not working after upgrade to 2.6.24
Date: Thu, 31 Jan 2008 14:35:49 +0200
Message-ID: <47A1C0A5.7090303@panasas.com>
References: <fnqka6$l46$1@ger.gmane.org> <47A19E26.30107@panasas.com> <47A1ABF8.4050408@upb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:10838 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764437AbYAaMgm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 07:36:42 -0500
In-Reply-To: <47A1ABF8.4050408@upb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?ISO-8859-15?Q?Sven_K=F6hler?= <skoehler@upb.de>, James Bottomley <James.Bottomley@SteelEye.com>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

On Thu, Jan 31 2008 at 13:07 +0200, Sven K=F6hler <skoehler@upb.de> wro=
te:
>> Yes the gdth driver passed an open hart surgery in kernel 2.6.24. Th=
e bad thing
>> about it is that all three of the Coders that did that did not have =
any HW to work
>> on. One of them is me. We did cry for tester for a long time but no =
one came forward.
>=20
> All i'd like to ask is WHY!?
> WHY such a big open heart surgery?
> OK, you have your reasons.
>=20
>> Could you test patches for us? first thing would be to enable debug =
output patch below.
>=20
> The machine is still production. It will be replaced by a 64bit syste=
m=20
> with an AACRAID card some time in the future. Then, i could maybe tes=
t=20
> patches on the old machine. But unfortunatly, it's not my machine. It=
's=20
> just administrated by me. And i don't know, what's exactly is the fut=
ure=20
> of it.
>=20
>> If you absolutely need a 2.6.24 kernel, + gdth in a production syste=
m you could
>> checkout the 2.6.23 driver and compile. The old driver will work the=
 same in 2.6.24.
>> It will not however even compile in 2.6.25-rcx.
>=20
> I see. Thanks for the hint. Would be an alternative. Actually, i don'=
t=20
> need 2.6.24 - but if something security related is fixed, then i'm no=
t=20
> able to move on to 2.6.24. And i'm using Gentoo. There's not really a=
=20
> kernel maintained by the distribution.
>=20
>> If any one wants to send me a card that uses the gdth driver, I will=
 be very happy
>> to debug this card, and return it once I'm done.
>=20
> I don't think, it's a seperate card, that i could send you. It's some=
=20
> 19" rack server with such a card on-board, i think.
>=20
>=20
> So it don't see much opportunity for me to test patched and stuff :-(
>=20

Thanks, Perhaps someone else then.=20
Anyone with gdth HW that can test patches?
Your lspci said: "Intel Corporation RAID Controller" Matthew
is there a gdth card lying around in an Intel lab near you?

James do we need to mark gdth BROKEN for 2.6.24 and higher?

Boaz
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
