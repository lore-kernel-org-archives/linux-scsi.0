From: Fabien Salvi <fabien@cri74.org>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 17:15:05 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDDDE09.2040602@cri74.org>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org> <3FDDC8FF.2090403@leosandbox.org> <3FDDC867.9040500@cri74.org> <3FDDCE2F.4030401@leosandbox.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aravis.cur-archamps.fr ([195.202.0.99]:23506 "EHLO
	aravis.cur-archamps.fr") by vger.kernel.org with ESMTP
	id S263702AbTLOQPI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 11:15:08 -0500
List-Id: linux-scsi@vger.kernel.org
To: r35157anc3 <leo@leosandbox.org>
Cc: linux-scsi@vger.kernel.org

You can communicate with other servers on the same SAN network also=20
using FC-IP.
I don't understand what you mean with "mount" ?
You have nothing to mount, it's a network interface like any other one=20
to use classic IP protocol.

It has nothing to do with iSCSI or something like that...


r35157anc3 a =E9crit:
> Thanks very much. I've made it as far as setting up the network devic=
es.=20
> I now have fc0 network device and with an internal ip, but I can't=20
> figure out how I am supposed to mount it? I can mount it over scsi? =20
> What if I am trying to access the fc remotely? I guess I just don't=20
> understand, but beyond setting up the qla2xip kernel drivers, the=20
> documentation doesn't say much.
>=20
> &Leo();
>=20
>=20
> Fabien Salvi wrote:
>=20
>> Hello, I've CC the email to the list, other people could be interest=
ed...
>>
>> Well, it wasn't very difficult.
>> After building qla2?00.o with IP option and building qlaip, you just=
=20
>> have to load these 2 modules.
>> Then, you can see a new network interface (see ifconfig -a).
>> You can use it like any ethernet devices...
>>
>> You may also encounter difficulties related to FC connection between=
=20
>> your servers. In my test, I was using Qlogic Sanbox2 switch with=20
>> broadcasting activated.
>>
>>
>> r35157anc3 a =E9crit:
>>
>>> Hello,
>>>
>>> Do you know where I can get instructions on setting up ip for qla? =
I=20
>>> configured the qla ip drivers. I just can't figure out how to mount=
=20
>>> after setting it up.
>>>
>>> &Leo();


--=20
=46abien SALVI

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
