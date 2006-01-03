From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: Booting from or using a Compaq RA4100 Array
Date: Tue, 3 Jan 2006 17:28:25 +0100
Message-ID: <200601031728.31886@bilbo.math.uni-mannheim.de>
References: <1135801791.9541.12.camel@gateway.markschaefer.org> <200601030851.30624@bilbo.math.uni-mannheim.de> <20060103123424.GJ19769@parisc-linux.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1296918.tvhFncRKo8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:57495 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1750795AbWACQ2q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2006 11:28:46 -0500
In-Reply-To: <20060103123424.GJ19769@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

--nextPart1296918.tvhFncRKo8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Matthew Wilcox:
>On Tue, Jan 03, 2006 at 08:51:30AM +0100, Rolf Eike Beer wrote:
>> >HPFC-5000 is the original HP Tachyon design which my driver won't
>> >support.  It doesn't have FCP support in hardware or anything.  My
>> >driver only does TachLite.
>> >
>> >My aim is to support the following boards:
>> >
>> >HP A5156A	HPFC-5100 /2.0	(TL)
>> >HP A5157A	HPFC-5100B/2.2	(TL) dual port
>> >HP A5158A	HPFC-5100C/2.3	(TL)
>> >HP A5158A	HPFC-5100D/3.0	(TL)
>> >HP A6795A	HPFC-5200C/2.2	(XL2)
>> >Compaq FC HBA   HPFC-5166A/1.2  (TS)
>>
>> Ok, can you collect such a list of the "other" cards that your driver does
>> not support? And a list of PCI ids that match both lists?
>
>You could make an effort here too.

But it sounded like Martin already knows :)

>> These are the devices supported by the original cpqfc driver:
>>
>> #define PCI_DEVICE_ID_COMPAQ_TACHYON    0xa0fc
>> #define PCI_DEVICE_ID_HP_TACHYON        0x1028
>> #define PCI_DEVICE_ID_HP_TACHLITE       0x1029
>>
>> I now own a Agilent HHBA-5121. What's that for a thing?
>
>Plugging "Agilent HHBA-5121" into google gets me a PDF with the following
> text:
>
>    At the heart of the HHBA-5121 is the HPFC-5166 Tachyon TS
>    Fibre Channel Interface Controller IC.

Sounds good :)

PCI id is 103c:102a.

Eike

--nextPart1296918.tvhFncRKo8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQBDuqYvXKSJPmm5/E4RAtdfAJ9xvCKGVRJp+OB5Hqj5Nyxz4qN2igCfZpoZ
PUzAt/DiVvopEMxHiaET7hI=
=Rfee
-----END PGP SIGNATURE-----

--nextPart1296918.tvhFncRKo8--
