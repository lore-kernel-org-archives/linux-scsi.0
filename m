From: Benny Halevy <bhalevy@panasas.com>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Mon, 11 Feb 2008 19:13:33 +0200
Message-ID: <47B0823D.1010008@panasas.com>
References: <20080208153217.5fc42a50@core> <1202486247.3102.17.camel@localhost.localdomain> <Pine.LNX.4.61.0802081104370.27386@chaos.analogic.com> <47AC82D7.2070502@compro.net> <Pine.LNX.4.61.0802111059270.8512@chaos.analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33823 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYBKROC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 12:14:02 -0500
In-Reply-To: <Pine.LNX.4.61.0802111059270.8512@chaos.analogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Mark Hounschell <markh@compro.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>

Seriously, can't you just add a disclaimer to the README file?

In http://lkml.org/lkml/2008/2/9/29, Luben Tuikov made an interesting
point that in many cases "illegal" refers to a valid value that violate=
s
the specification, so the term "invalid" may be technically incorrect.

Benny

On Feb. 11, 2008, 18:07 +0200, "linux-os (Dick Johnson)" <linux-os@anal=
ogic.com> wrote:
> On Fri, 8 Feb 2008, Mark Hounschell wrote:
>=20
>> linux-os (Dick Johnson) wrote:
>>> The correct word should be "invalid," in spite of
>>> the fact that the SCSI committee used invalid syntax.
>>>
>>> Alan is right. There is nothing illegal in the kernel
>>> and if there is, it must be removed as soon as it
>>> is discovered!
>>>
>> il=B7le=B7gal  (-lgl)
>> adj.
>> 1. Prohibited by law.
>> *2. Prohibited by official rules: an illegal pass in football.
>> *3. Unacceptable to or not performable by a computer: an illegal ope=
ration.
>>
>> Mark
>=20
> Many early computer programmers including myself, while writing
> error messages in early software, did not understand that computer
> programmers do not make law so we called bad operations "illegal."
>=20
> Once you are called to testify in a court of law, about some
> message your code wrote to the screen just before a factory
> burned down, you start to be much more careful about the syntax.
>=20
> I advise that, regardless of the rewrite of dictionaries and,
> in fact, the rewrite of history, whenever possible we use
> the correct message syntax. Dictionaries pick up "common usage"
> in spite of the fact that it is wrong. See "irregardless" and
> other abortions which now exist in the dictionary.
>=20
>=20
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips=
).
> My book : http://www.AbominableFirebug.com/
> _
>=20
> ****************************************************************
> The information transmitted in this message is confidential and may b=
e privileged.  Any review, retransmission, dissemination, or other use =
of this information by persons or entities other than the intended reci=
pient is prohibited.  If you are not the intended recipient, please not=
ify Analogic Corporation immediately - by replying to this message or b=
y sending an email to DeliveryErrors@analogic.com - and destroy all cop=
ies of this information, including any attachments, without reading or =
disclosing them.
>=20
> Thank you.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
