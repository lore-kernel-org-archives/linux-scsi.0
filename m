From: Fabien Salvi <fabien@cri74.org>
Subject: Re: [FEATURE REQUEST] megaraid2 driver
Date: Thu, 22 Apr 2004 12:11:18 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40879A46.4090603@cri74.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC510@exa-atlanta.se.lsil.com> <Pine.LNX.4.58.0404210952220.29661@les5.10east.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:41917 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263893AbUDVKLT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Apr 2004 06:11:19 -0400
In-Reply-To: <Pine.LNX.4.58.0404210952220.29661@les5.10east.com>
List-Id: linux-scsi@vger.kernel.org
To: Lester Hightower <hightowe@10east.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Lester Hightower a =E9crit :
> Atul / readers of linux-scsi,

 > [...]

> Yesterday we ran a test where we pulled a drive from a logical drive =
set
> that had a hot spare.  The MegaRaid card rebuilt automatically, and a=
fter
> we inserted a fresh disk it automatically marked as a hot spare.  Tha=
t
> went well, however, it took almost two hours to rebuild 73G on u320 d=
isks
> in raid-1, which surprised me since the Mylex Acceleraid 170 (u160) t=
ook
> less than an hour in the same test. =20

Well, not very surprising. Speed can vary from one manufacturer to anot=
her.
It also depends of the priority given to this task...

> One thing the DAC960 driver does is publish the real-time progress of=
 a
> rebuild operation, both in /proc and by klog every few minutes.  The =
Linux
> MegaRaid driver is completely silent start to finish, only showing th=
at it
> is in a Rebuild state.  Because the DAC960 card had already given us =
an
> idea of how much time to expect the rebuild to take, the second hour =
that
> the MegaRaid consumed was unnerving, and primarily due to the fact th=
at we
> had no rebuild progress indication available to us.

It's not the driver's job to display this...

> I searched through all of the structs in megariad2.h and do not readi=
ly
> see any data available that would indicate the progress of a rebuild,=
 else
> I would code this myself and submit a patch.  Instead I am asking Atu=
l,
> and anyone else with expertise in this area, for assistance or advice=
 in
> implementing that feature.

You should look at userland utilities to manager your RAID controller.
I've not tested them with megaraid2 driver, but you should look at=20
LSILogic support web site to get utilities (GAM, Megamgr, etc...).

--=20
=46abien SALVI
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
