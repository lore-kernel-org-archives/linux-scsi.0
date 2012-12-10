From: Chen Gang <gang.chen@asianux.com>
Subject: Re: [Suggestion] drivers/target/sbp/ : set tport->tpg to NULL when
 clean up for failure.
Date: Mon, 10 Dec 2012 10:39:05 +0800
Message-ID: <50C54B49.6020000@asianux.com>
References: <50C01E16.5080303@asianux.com> <50C058A4.7030403@bootc.net> <50C05A02.6080401@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <50C05A02.6080401@asianux.com>
Sender: target-devel-owner@vger.kernel.org
To: Chris Boot <bootc@bootc.net>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Hello Chris Boot:

  need I send the relative patch ?

  Regards

gchen.


=D3=DA 2012=C4=EA12=D4=C206=C8=D5 16:40, Chen Gang =D0=B4=B5=C0:
> =D3=DA 2012=C4=EA12=D4=C206=C8=D5 16:34, Chris Boot =D0=B4=B5=C0:
>> On 06/12/12 04:24, Chen Gang wrote:
>>> Hello Maintainers:=20
>>>
>>> in drivers/target/sbp/sbp_target.c:
>>>
>>>    tport->tpg must be NULL before process it in function sbp_make_t=
pg. (line 2185..2188)
>>>    tport->tpg assigned a ptr (line 2198)
>>>    if processing failed, not set tport->tpg =3D NULL (line 2208..22=
12, 2217..2221)
>>>
>>>    we have done: when free tport->tpg, set it to NULL (line 2233..2=
234)
>>>
>>>    is it valuable to let tport->tpg =3D NULL, when clean up for fai=
lure ?
>>>
>> <snip>
>>
>> Yes, that's a good catch. The way it is now, if we fail to set up th=
e
>> TPG, the port will be left in an inconsistent state. I'll prepare a
>> patch ASAP unless you'd rather do it yourself.
>>
>> Thanks,
>> Chris
>>
>=20
>   please help do it (better to mark me as Reported-by in your patch).
>=20
>   thanks.
>=20
>   :-)
>=20
>=20


--=20
Chen Gang

Asianux Corporation
