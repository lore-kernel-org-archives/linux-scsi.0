From: Bernd Schubert <bernd-schubert@web.de>
Subject: Re: i/o errors
Date: Wed, 23 Jun 2004 17:08:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200406231708.40264.bernd-schubert@web.de>
References: <200406231142.56957.bernd-schubert@web.de> <40D98D10.4090205@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.uni-heidelberg.de ([129.206.100.212]:11154 "EHLO
	relay.uni-heidelberg.de") by vger.kernel.org with ESMTP
	id S266551AbUFWPIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2004 11:08:49 -0400
In-Reply-To: <40D98D10.4090205@cri74.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

> I won't be surprised if it's a hardware related problem.
> Do you know which is the real manufacturer of the RAID controller and
> firmware ? I don't think Transtec make their own system...

As far as I know its an Infortrend device, at least the manual and usag=
e=20
information are similar with an infortrend device. If you have interest=
, I=20
could try to find out which of the infortrend devices it is.

>
> IMHO, you should try big bench without DRDB using I/O benchmark tool =
and
> also simply dd to make big parallel transfers and check if you can
> reproduce the bug. It would be interested, if you get the bug, to try
> with other linux kernel revision and also other OS...

Of course, I already performed those benchmarks, however only on the=20
filesystem and I never could reproduce those bugs. Tomorrow afternoon I=
 will=20
try what happens without the filesystem.
Maybe the filesystem layer speed degrading is sufficient to prevent the=
 bug.=20
When the problem first occured and asked Justin about it, he told me to=
 use=20
his newer driver versions. Then I really thought that it is a driver bu=
g,=20
because it got worse with every driver revision. Finally Justin told me=
 that=20
every revision became slightly faster - this slight speed increase was =
enough=20
to reliably trigger this bug :/

We are trying to fix this bug for more than four weeks now, and finally=
 we=20
would like to use our new storage server. However, I'm really worried t=
hat=20
this problem will occur during the real usage, though my tests showed t=
hat it=20
shouldn't happen in real live.


I really would prever not to use an other OS, since I have no recent=20
experience with them.

>
> Good luck!

Thanks at  lot!


Cheers,
	Bernd


--=20
Bernd Schubert
Physikalisch Chemisches Institut / Theoretische Chemie
Universit=E4t Heidelberg
INF 229
69120 Heidelberg
e-mail: bernd.schubert@pci.uni-heidelberg.de
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
