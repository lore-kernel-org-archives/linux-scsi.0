From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Bad fibre channel performance: need howto
Date: Mon, 24 Nov 2003 16:26:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FC22337.3020105@cri74.org>
References: <1069443458.7047.35.camel@cala>  <3FC1E393.4090907@cri74.org> <1069673445.1231.18.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:6312 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263763AbTKXP0s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 10:26:48 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mario Giammarco <mgiammarco@virgilio.it>
Cc: linux-scsi@vger.kernel.org



Mario Giammarco a =E9crit:
> Il lun, 2003-11-24 alle 11:55, Fabien Salvi ha scritto:
>=20
>=20
>>Hello Mario,
>>
>=20
>=20
>=20
>>If you want, I can send you an archive of the howto.
>>I've downloaded it a long time ago, before sistina removed it from th=
eir=20
>>server.
>>
>>But, it's true, it's a bit old
>=20
>=20
> Yes send it to me please. I like to read all.

Here :
ftp://ftp.cri74.org/incoming/services/3c6caf61efc733e03526edac45852ad1/=
fibrechannel_howto.tar.bz2

>>About your problem, I am not sure it's really because of FibreChannel=
=2E
>>There are a lot of differences between theorical values and real ones=
=2E
>>Which tool are you using for the benchmark ?
>=20
>=20
> I know but usually the "sequential read" is the easiest test to disco=
ver
> if there are problems.
>=20
> I have used hdparm and sg3 tools to do a quick sequential read test.
> On ide world if hdparm tells me that I have  sequential transfer rate
> lower than shown on web reviews it means that I have to tweak dma, et=
c.
> and usually after tweaking I get performance promised.
>=20
> Here there is little to tweak and I then discovered with a serious te=
st
> (tiobench) that write performance is also worse.
>=20
> I suppose there is some problem.
>=20
> I am now buying a qlogic2200 to try if it is better.
> Can someone tell me best drivers for qlogic2200?

I use qlogic 2200 FC HBA with the official qlogic driver and it works=20
fine. Look at:=20
http://www.qlogic.com/support/os_detail.asp?productid=3D113&osid=3D26

--=20
=46abien SALVI      Centre de Ressources Informatiques
                   Archamps, France -- http://www.cri74.org
                   PingOO GNU/linux distribution : http://www.pingoo.or=
g

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
