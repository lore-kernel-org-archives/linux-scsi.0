From: =?windows-1252?Q?Martin_MOKREJ=8A?=
	<mmokrejs@ribosome.natur.cuni.cz>
Subject: Re: scsi1:0:4:0: Attempting to queue an ABORT message
Date: Tue, 21 Jun 2005 21:40:43 +0200
Message-ID: <42B86D3B.3080301@ribosome.natur.cuni.cz>
References: <42B8598F.70203@ribosome.natur.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from r3az252.chello.upc.cz ([213.220.243.252]:5261 "EHLO
	aquarius.doma") by vger.kernel.org with ESMTP id S262305AbVFUTks
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2005 15:40:48 -0400
In-Reply-To: <42B8598F.70203@ribosome.natur.cuni.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The problem doesn't appear when using http://download.adaptec.com/scsi/=
linux/aic7Yxx-2.0.14-6.3.11-linux-2.4.tar.bz2
driver. I have simply replaced the aic7xxx subdirectory of vanilla 2.4.=
31 and done
make dep; make bzImage; make modules as usually.

Could someone at least tell me which change fixed possibly my problem
so I'd ask on linux-kernel list to get the patch included?
Or will someone take over this initiative and push even the 6.3.11 driv=
er
into 2.4 and 2.6 kernels? ;)

I believe same problem was reported by Yogesh Bhanu with subject
"Adpatec AIC7xxx problems " today too. I believe he has almost same har=
dware
from the same vendor. ;)
M.

Martin MOKREJ=8A wrote:
> Hi,
>  I have asked on this list few weeks ago but received no answer at al=
l. :(
> Now I'm retrying again as I still have problems, at the moment with=20
> 2.4.31 kernel.
> could someone explain me what is wrong? I get the messages when the=20
> machine boots
> and only once I got it while running several weeks/months without reb=
oot.
> Thanks for help!
> Martin
>=20
> Jun 20 23:37:14 oxygen scsi1:0:4:0: Attempting to queue an ABORT mess=
age
> Jun 20 23:37:14 oxygen CDB: 0x12 0x0 0x0 0x0 0x32 0x0
> Jun 20 23:37:14 oxygen scsi1: At time of recovery, card was not pause=
d
> Jun 20 23:37:14 oxygen >>>>>>>>>>>>>>>>>> Dump Card State Begins=20
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
