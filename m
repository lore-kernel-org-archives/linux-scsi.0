From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 18:17:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDDEC90.4020403@cri74.org>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org> <3FDDC8FF.2090403@leosandbox.org> <3FDDC867.9040500@cri74.org> <3FDDCE2F.4030401@leosandbox.org> <3FDDDE09.2040602@cri74.org> <3FDDE685.6050601@leosandbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:3034 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263871AbTLORRG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 12:17:06 -0500
List-Id: linux-scsi@vger.kernel.org
To: r35157anc3 <leo@leosandbox.org>
Cc: linux-scsi@vger.kernel.org



r35157anc3 a =E9crit:
> I've isolated myself from the SAN network and I'm operating in my own=
=20
> private subnet. It's just my server, the FC controller, and a hard dr=
ive=20
> connected to the controller.
>=20
> I want to connect to devices interfaced with the FC over IP. I have a=
=20
> hard drive interfaced with a qla 2300 controller. Now that I have the=
 FC=20
> setup for IP, how would I mount that disk?
>=20
> Perhaps I'm going about this all wrong though.=20

Yes !
You can't mount devices using IP over FC.
You can only access other FC nodes (essentially servers) that also have=
=20
IP over FC activated.
It could be useful for example to share storage over NFS in a cluster=20
connected to the same SAN, because there are not many Shared FileSystem=
=20
(except GFS but it's no longer GPL...).

> I always thought IP was=20
> an alternative to SCSI for FC. Usually, I mount my SCSI devices. If I=
'm=20
> not going to use SCSI, then how do I use it if not by mounting?

No, you won't be able to mount your SCSI devices.
If you want to this, use SCSI over FC, it's the traditionnal way to do =
it.
You *really* have no interest, even it would be possible, to use IP to=20
mount SCSI devices...


--=20
=46abien SALVI

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
