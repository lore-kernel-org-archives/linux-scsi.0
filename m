From: r35157anc3 <leo@leosandbox.org>
Subject: Re: Status of qlogic tcp/ip (fc0) support
Date: Mon, 15 Dec 2003 09:51:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FDDE685.6050601@leosandbox.org>
References: <1071483139.1433.3.camel@cala> <3FDD9D52.2060405@cri74.org> <3FDDC8FF.2090403@leosandbox.org> <3FDDC867.9040500@cri74.org> <3FDDCE2F.4030401@leosandbox.org> <3FDDDE09.2040602@cri74.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from deagol.email.Arizona.EDU ([128.196.133.142]:49087 "EHLO
	smtpgate.email.arizona.edu") by vger.kernel.org with ESMTP
	id S263768AbTLOQox (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Dec 2003 11:44:53 -0500
In-Reply-To: <3FDDDE09.2040602@cri74.org>
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>
Cc: linux-scsi@vger.kernel.org

I've isolated myself from the SAN network and I'm operating in my own=20
private subnet. It's just my server, the FC controller, and a hard driv=
e=20
connected to the controller.

I want to connect to devices interfaced with the FC over IP. I have a=20
hard drive interfaced with a qla 2300 controller. Now that I have the F=
C=20
setup for IP, how would I mount that disk?

Perhaps I'm going about this all wrong though. I always thought IP was=20
an alternative to SCSI for FC. Usually, I mount my SCSI devices. If I'm=
=20
not going to use SCSI, then how do I use it if not by mounting?

Thanks for being so helpful,
&Leo();

=46abien Salvi wrote:

> You can communicate with other servers on the same SAN network also=20
> using FC-IP.
> I don't understand what you mean with "mount" ?
> You have nothing to mount, it's a network interface like any other on=
e=20
> to use classic IP protocol.
>
> It has nothing to do with iSCSI or something like that...
>
>
> r35157anc3 a =E9crit:
>
>> Thanks very much. I've made it as far as setting up the network=20
>> devices. I now have fc0 network device and with an internal ip, but =
I=20
>> can't figure out how I am supposed to mount it? I can mount it over=20
>> scsi?  What if I am trying to access the fc remotely? I guess I just=
=20
>> don't understand, but beyond setting up the qla2xip kernel drivers,=20
>> the documentation doesn't say much.
>>
>> &Leo();
>>
>>
>> Fabien Salvi wrote:
>>
>>> Hello, I've CC the email to the list, other people could be=20
>>> interested...
>>>
>>> Well, it wasn't very difficult.
>>> After building qla2?00.o with IP option and building qlaip, you jus=
t=20
>>> have to load these 2 modules.
>>> Then, you can see a new network interface (see ifconfig -a).
>>> You can use it like any ethernet devices...
>>>
>>> You may also encounter difficulties related to FC connection betwee=
n=20
>>> your servers. In my test, I was using Qlogic Sanbox2 switch with=20
>>> broadcasting activated.
>>>
>>>
>>> r35157anc3 a =E9crit:
>>>
>>>> Hello,
>>>>
>>>> Do you know where I can get instructions on setting up ip for qla?=
=20
>>>> I configured the qla ip drivers. I just can't figure out how to=20
>>>> mount after setting it up.
>>>>
>>>> &Leo();
>>>
>
>

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
