From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 15:42:47 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDDC867.9040500@cri74.org>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org> <3FDDC8FF.2090403@leosandbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:31942 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263723AbTLOOmt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 09:42:49 -0500
List-Id: linux-scsi@vger.kernel.org
To: r35157anc3 <leo@leosandbox.org>
Cc: linux-scsi@vger.kernel.org

Hello, I've CC the email to the list, other people could be interested.=
=2E.

Well, it wasn't very difficult.
After building qla2?00.o with IP option and building qlaip, you just=20
have to load these 2 modules.
Then, you can see a new network interface (see ifconfig -a).
You can use it like any ethernet devices...

You may also encounter difficulties related to FC connection between=20
your servers. In my test, I was using Qlogic Sanbox2 switch with=20
broadcasting activated.


r35157anc3 a =E9crit:
> Hello,
>=20
> Do you know where I can get instructions on setting up ip for qla? I=20
> configured the qla ip drivers. I just can't figure out how to mount=20
> after setting it up.
>=20
> &Leo();
>=20
> Fabien Salvi wrote:
>=20
>>
>>
>> Mario Giammarco a =E9crit:
>>
>>> Hello,
>>> I now have a qlogic 2200 card and I am trying tcp/ip support:
>>>
>>> - standard qlogicfc built in kernel seems to not support ip (I hear=
d
>>> there is a patch somewhere, is it right?)
>>>
>>> - qla drivers 6.00 of qlogic website should support it but I am not=
 able
>>> to compile them with IP=3D1 option (I have tried on kernels 2.4.22 =
2.4.23)
>>
>>
>>
>> Hello, using qla2200 from qlogic is IMHO the good solution.
>> I've already tested it a few months ago and it worked fine except ve=
ry=20
>> poor performance (around 20MB/s with a Qlogic switch despite of no=20
>> load at all).
>>
>> You should send your compile errors...



--=20
=46abien SALVI

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
