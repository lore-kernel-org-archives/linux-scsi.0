From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Bad fibre channel performance: need howto
Date: Mon, 24 Nov 2003 11:55:15 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC1E393.4090907@cri74.org>
References: <1069443458.7047.35.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:15240 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263717AbTKXKzS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 05:55:18 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mario Giammarco <mgiammarco@virgilio.it>
Cc: linux-scsi@vger.kernel.org



Mario Giammarco a =E9crit:
> Hello,
> I asked a similar question last week.
> I discovered that my hard disk which can do 60mb/sec sequential read,
> under linux/lsilogic40909 fibre hba gives only 30mb/sec, 45 if I twea=
k a
> lot readahead (why  I need to?).
>=20
> I have searched a lot in internet and it seems that:
>=20
> 1) fibrechannel howto was in sistina home page but now disappeared
> 2) fibrechannel specific mailing list for linux disappeared (archives
> to)
>=20
> Where can I search for help?=20
> Here it not seems appropriate to me.=20
>=20
> I have to find my bottleneck, please help with sending me docs.
>=20

Hello Mario,

If you want, I can send you an archive of the howto.
I've downloaded it a long time ago, before sistina removed it from thei=
r=20
server.

But, it's true, it's a bit old. Therefore, there are some basic=20
informations about protocol that could have some interest.

About your problem, I am not sure it's really because of FibreChannel.
There are a lot of differences between theorical values and real ones.
Which tool are you using for the benchmark ?


--=20
=46abien SALVI

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
