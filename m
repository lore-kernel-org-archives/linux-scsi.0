From: r35157anc3 <leo@leosandbox.org>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 08:07:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDDCE2F.4030401@leosandbox.org>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org> <3FDDC8FF.2090403@leosandbox.org> <3FDDC867.9040500@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deagol.email.Arizona.EDU ([128.196.133.142]:35552 "EHLO
	smtpgate.email.arizona.edu") by vger.kernel.org with ESMTP
	id S263702AbTLOPBB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 10:01:01 -0500
In-Reply-To: <3FDDC867.9040500@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org

Thanks very much. I've made it as far as setting up the network devices=
=2E=20
I now have fc0 network device and with an internal ip, but I can't=20
figure out how I am supposed to mount it? I can mount it over scsi? =20
What if I am trying to access the fc remotely? I guess I just don't=20
understand, but beyond setting up the qla2xip kernel drivers, the=20
documentation doesn't say much.

&Leo();


=46abien Salvi wrote:

> Hello, I've CC the email to the list, other people could be intereste=
d...
>
> Well, it wasn't very difficult.
> After building qla2?00.o with IP option and building qlaip, you just=20
> have to load these 2 modules.
> Then, you can see a new network interface (see ifconfig -a).
> You can use it like any ethernet devices...
>
> You may also encounter difficulties related to FC connection between=20
> your servers. In my test, I was using Qlogic Sanbox2 switch with=20
> broadcasting activated.
>
>
> r35157anc3 a =E9crit:
>
>> Hello,
>>
>> Do you know where I can get instructions on setting up ip for qla? I=
=20
>> configured the qla ip drivers. I just can't figure out how to mount=20
>> after setting it up.
>>
>> &Leo();
>>
>> Fabien Salvi wrote:
>>
>>>
>>>
>>> Mario Giammarco a =E9crit:
>>>
>>>> Hello,
>>>> I now have a qlogic 2200 card and I am trying tcp/ip support:
>>>>
>>>> - standard qlogicfc built in kernel seems to not support ip (I hea=
rd
>>>> there is a patch somewhere, is it right?)
>>>>
>>>> - qla drivers 6.00 of qlogic website should support it but I am no=
t=20
>>>> able
>>>> to compile them with IP=3D1 option (I have tried on kernels 2.4.22=
=20
>>>> 2.4.23)
>>>
>>>
>>>
>>>
>>> Hello, using qla2200 from qlogic is IMHO the good solution.
>>> I've already tested it a few months ago and it worked fine except=20
>>> very poor performance (around 20MB/s with a Qlogic switch despite o=
f=20
>>> no load at all).
>>>
>>> You should send your compile errors...
>>
>
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
