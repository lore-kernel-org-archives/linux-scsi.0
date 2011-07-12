From: ersatz splatt <ersatzsplatt@gmail.com>
Subject: Re: pm8001 performance degradation?
Date: Mon, 11 Jul 2011 19:46:25 -0700
Message-ID: <CAHQAjVFm95Czhz=P7r_OX1NUuw_nipubn=imaKAsT+a0R5sVuw@mail.gmail.com>
References: <CAHQAjVFuvh72uJ4x9g-P0XrihfWfUt1YtipTJgd9iXzTS+Vz=w@mail.gmail.com>
	<316E3E573B654596BA694678AE395999@usish.com.cn>
	<CAHQAjVG_cvvEX99A4ma5waSMs6hjWB_Bgy0oDZ4LgyzwwOpcjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63006 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1GLCq1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2011 22:46:27 -0400
Received: by wyg8 with SMTP id 8so2971497wyg.19
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2011 19:46:25 -0700 (PDT)
In-Reply-To: <CAHQAjVG_cvvEX99A4ma5waSMs6hjWB_Bgy0oDZ4LgyzwwOpcjQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: lindar_liu@usish.com, linux-scsi@vger.kernel.org

Please let me know if you would like any more details.

Can you point to the degradation reference in earlier mail?



On Mon, Jul 11, 2011 at 7:44 PM, ersatz splatt <ersatzsplatt@gmail.com>=
 wrote:
> I have one HBA connected directly to 4 SAS drives ... using a single =
1
> to four cable.
>
>
> On Mon, Jul 11, 2011 at 6:27 PM, Jack Wang <jack_wang@usish.com> wrot=
e:
>>> Hello Jack Wang and Lindar Liu,
>>>
>>>
>>> I am running the pm8001 driver (on applicable hardware including a
>>> several core SMP server).
>>>
>>> When I run on an older kernel -- e.g. 2.6.34.7 -- I get about 73Kio=
ps
>>> via an fio test.
>>>
>>> When I run a current kernel -- e.g. 2.6.39.2 -- on the same system =
and
>>> same storage I get about 15Kiops running the same fio test.
>>>
>>> Perhaps something has changes in the kernel that is not being accou=
nted
>> for?
>>> Are you two still maintaining this driver?
>>>
>>>
>>> Regards,
>>> David
>> [Jack Wang] =A0Could you give your detailed topology, I will later t=
ry to
>> investigate the performance issue, but as I remember an Intel develo=
per
>> reports in mailist some changes in block layer lead to JBOD performa=
nce
>> degradation.
>>
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
