From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 12:38:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDD9D52.2060405@cri74.org>
References: <1071483139.1433.3.camel@cala>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:40880 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S262566AbTLOLjA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 06:39:00 -0500
List-Id: linux-scsi@vger.kernel.org
To: Mario Giammarco <mgiammarco@virgilio.it>
Cc: linux-scsi@vger.kernel.org



Mario Giammarco a =E9crit:
> Hello,
> I now have a qlogic 2200 card and I am trying tcp/ip support:
>=20
> - standard qlogicfc built in kernel seems to not support ip (I heard
> there is a patch somewhere, is it right?)
>=20
> - qla drivers 6.00 of qlogic website should support it but I am not a=
ble
> to compile them with IP=3D1 option (I have tried on kernels 2.4.22 2.=
4.23)

Hello, using qla2200 from qlogic is IMHO the good solution.
I've already tested it a few months ago and it worked fine except very=20
poor performance (around 20MB/s with a Qlogic switch despite of no load=
=20
at all).

You should send your compile errors...

--=20
=46abien SALVI

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
