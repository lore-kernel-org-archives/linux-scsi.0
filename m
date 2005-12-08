From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel] stgt a new version
 of iscsi target?
Date: Thu, 08 Dec 2005 12:54:07 -0600
Message-ID: <4398814F.7000106@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins> <43972C2D.9060500@cs.wisc.edu> <43987F75.2000301@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:26085 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932210AbVLHSy2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 13:54:28 -0500
In-Reply-To: <43987F75.2000301@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
> Mike Christie wrote:
>=20
>> johan@capvert.se wrote:
>>
>>> I, and I suppose a lot of other people, would like know how you loo=
k=20
>>> at the
>>> HW support on the Fc side? I don=B4t know what you mean now, when y=
ou talk
>>> about HW target support,=20
>>
>>
>> For qlogic FC, it is the same as scst at this point, except we are=20
>> based off the mainline qla2xxx driver.
>=20
>=20
> Actually, this is not completely true and could mislead people.  Stgt=
 is
> *not* the same as scst at this point and,

Yes, I agree, I was not talking about functionality. I was only talking=
=20
about how we interface with the initiator driver. My mistake. So we add=
=20
a qla_tgt function callback struct (but we do it for each ha rather tha=
n=20
global) so the initiator can call back into the target driver, so I am=20
basically resusing that code.
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
