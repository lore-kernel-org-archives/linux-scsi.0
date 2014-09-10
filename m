From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump feature support
Date: Wed, 10 Sep 2014 12:08:19 +0200
Message-ID: <54102313.1090604@redhat.com>
References: <201409061328.s86DS6lO012975@palmhbs0.lsi.com> <540F22A2.3040906@redhat.com> <94D0CD8314A33A4D9D801C0FE68B402958C6C617@G9W0745.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbaIJKIw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2014 06:08:52 -0400
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C6C617@G9W0745.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "Sumit.Saxena@avagotech.com" <Sumit.Saxena@avagotech.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, "kashyap.desai@avagotech.com" <kashyap.desai@avagotech.com>, "aradford@gmail.com" <aradford@gmail.com>

On 09/09/2014 06:18 PM, Elliott, Robert (Server Storage) wrote:
>
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Tomas Henzl
>> Sent: Tuesday, 09 September, 2014 10:54 AM
>> Subject: Re: [PATCH 04/11] megaraid_sas : Firmware crash dump featur=
e
>> support
>>
>> On 09/06/2014 03:25 PM, Sumit.Saxena@avagotech.com wrote:
>>> This feature will provide similar interface as kernel crash dump
>> feature.
>>> When megaraid firmware encounter any crash, driver will collect the
>> firmware raw image and
>>> dump it into pre-configured location.
>>>
> ...
>> With several controllers in a system this may take a lot memory,
>> could you also
>> in case when a kdump kernel is running lower it, by not using this
>> feature?
> What is the correct way for a driver to determine that it is
> running in a kdump kernel?  The reset_devices global variable?

Yes reset_devices is used for this purpose.
I think, that I've seen some drivers even trying to reduce the normal
mem use, because a top performance is not needed.

>
>
> ---
> Rob Elliott    HP Server Storage
>
>
>
> N=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDr=EF=BF=BD=EF=BF=BDy=EF=
=BF=BD=EF=BF=BD=EF=BF=BDb=EF=BF=BDX=EF=BF=BD=EF=BF=BD=C7=A7v=EF=BF=BD^=EF=
=BF=BD)=DE=BA{.n=EF=BF=BD+=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD{=EF=BF=BD=
=EF=BF=BD=EF=BF=BD"=EF=BF=BD{ay=EF=BF=BD=1D=CA=87=DA=99=EF=BF=BD,j=07=EF=
=BF=BD=EF=BF=BDf=EF=BF=BD=EF=BF=BD=EF=BF=BDh=EF=BF=BD=EF=BF=BD=EF=BF=BD=
z=EF=BF=BD=1E=EF=BF=BDw=EF=BF=BD=EF=BF=BD=EF=BF=BD=0C=EF=BF=BD=EF=BF=BD=
=EF=BF=BDj:+v=EF=BF=BD=EF=BF=BD=EF=BF=BDw=EF=BF=BDj=EF=BF=BDm=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=07=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BDzZ+=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=DD=A2j"=EF=BF=BD=EF=BF=BD!tml=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
