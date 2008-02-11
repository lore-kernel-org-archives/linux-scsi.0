From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
Date: Mon, 11 Feb 2008 11:07:39 -0500
Message-ID: <Pine.LNX.4.61.0802111059270.8512@chaos.analogic.com>
References: <20080208153217.5fc42a50@core> <1202486247.3102.17.camel@localhost.localdomain> <Pine.LNX.4.61.0802081104370.27386@chaos.analogic.com> <47AC82D7.2070502@compro.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from spirit.analogic.com ([204.178.40.4]:3692 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756684AbYBKQH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Feb 2008 11:07:56 -0500
Content-class: urn:content-classes:message
In-Reply-To: <47AC82D7.2070502@compro.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Hounschell <markh@compro.net>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org, Linux kernel <linux-kernel@vger.kernel.org>


On Fri, 8 Feb 2008, Mark Hounschell wrote:

> linux-os (Dick Johnson) wrote:
>>
>> The correct word should be "invalid," in spite of
>> the fact that the SCSI committee used invalid syntax.
>>
>> Alan is right. There is nothing illegal in the kernel
>> and if there is, it must be removed as soon as it
>> is discovered!
>>
>
> il=B7le=B7gal  (-lgl)
> adj.
> 1. Prohibited by law.
> *2. Prohibited by official rules: an illegal pass in football.
> *3. Unacceptable to or not performable by a computer: an illegal oper=
ation.
>
> Mark

Many early computer programmers including myself, while writing
error messages in early software, did not understand that computer
programmers do not make law so we called bad operations "illegal."

Once you are called to testify in a court of law, about some
message your code wrote to the screen just before a factory
burned down, you start to be much more careful about the syntax.

I advise that, regardless of the rewrite of dictionaries and,
in fact, the rewrite of history, whenever possible we use
the correct message syntax. Dictionaries pick up "common usage"
in spite of the fact that it is wrong. See "irregardless" and
other abortions which now exist in the dictionary.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
My book : http://www.AbominableFirebug.com/
_

****************************************************************
The information transmitted in this message is confidential and may be =
privileged.  Any review, retransmission, dissemination, or other use of=
 this information by persons or entities other than the intended recipi=
ent is prohibited.  If you are not the intended recipient, please notif=
y Analogic Corporation immediately - by replying to this message or by =
sending an email to DeliveryErrors@analogic.com - and destroy all copie=
s of this information, including any attachments, without reading or di=
sclosing them.

Thank you.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
