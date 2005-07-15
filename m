From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Thu, 14 Jul 2005 21:53:09 -0300
Message-ID: <20050715005309.GB14816@ime.usp.br>
References: <1120926901.5008.12.camel@mulgrave> <200507091656.j69GuP5Y028863@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout6.uol.com.br ([200.221.4.197]:22422 "EHLO
	smtp.uol.com.br") by vger.kernel.org with ESMTP id S263117AbVGOAxN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2005 20:53:13 -0400
Received: from dumont.rtb.ath.cx (unknown [200.221.104.251])
	by scorpion6.uol.com.br (Postfix) with ESMTP id 41B057D4D
	for <linux-scsi@vger.kernel.org>; Thu, 14 Jul 2005 21:53:10 -0300 (BRT)
Content-Disposition: inline
In-Reply-To: <200507091656.j69GuP5Y028863@einhorn.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, bcollins@debian.org, James.Bottomley@SteelEye.com, arjan@infradead.org

=46irst of all, thank you very much for still taking this issue into
consideration.

Unfortunately, I was submitted to a surgery and only now I am recovered
enough to have access to computers (and I experienced the worst pains t=
hat
I have ever felt in my entire life this past week).

Anyway, I will still keep the data that I have on
<http://www.ime.usp.br/~rbrito/bug/> if it helps chasing the bug.

On Jul 09 2005, Stefan Richter wrote:
> On  9 Jul, James Bottomley wrote:
> > What's the breakage?
>=20
> There was one report from a -mm tester (Rog=E9rio Brito) who needed t=
o
> revert the TYPE_RBC changes to sbp2.[ch]. Else the initial inquiry wo=
uld
> fail. See the link to the archive in my initial post. Summary of that
> report:
(...)
> To make the matter a bit more complicated, Rog=E9rio's FireWire disk =
has
> got another problem with the ieee1394 base driver. Rog=E9rio and I wi=
ll
> try to work these two (perhaps orthogonal) problems out.

If you want me to experiment with anything, please let me know.

Already reporting to James the contents of
/sys/class/scsi_device/<dev>/device/type when the device isn't configur=
ed
(I'm using a -rc2-mm1 kernel here; vanilla -mm, that is), I get:

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -
rbrito@dumont:~$ cat /sys/class/scsi_device/0\:0\:0\:0/device/type=20
14
rbrito@dumont:~$=20
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -=
 - -

If anything else is important, please, don't hesitate to ask.


Thank you very much, Rog=E9rio.

--=20
Rog=E9rio Brito : rbrito@ime.usp.br : http://www.ime.usp.br/~rbrito
Homepage of the algorithms package : http://algorithms.berlios.de
Homepage on freshmeat:  http://freshmeat.net/projects/algorithms/
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
