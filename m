From: =?GB2312?B?0Lu42Q==?= <xiegang112@gmail.com>
Subject: Re: scsi traffic sniffing
Date: Wed, 2 Sep 2009 12:49:14 +0800
Message-ID: <d364733c0909012149sb5f780cia8acdc305535d376@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
	 <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
	 <d364733c0909012012s1c75434au6a2230e07af4241c@mail.gmail.com>
	 <48e952f40909012120y1d56bb6bha18330fa3266ed64@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:64375 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbZIBEtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 00:49:13 -0400
Received: by vws33 with SMTP id 33so558031vws.33
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2009 21:49:14 -0700 (PDT)
In-Reply-To: <48e952f40909012120y1d56bb6bha18330fa3266ed64@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan Nell <crtrn13@gmail.com>
Cc: linux-scsi@vger.kernel.org

2009/9/2 Jonathan Nell <crtrn13@gmail.com>:
> 2009/9/2 =D0=BB=B8=D9 <xiegang112@gmail.com>:
>> On Tue, Sep 1, 2009 at 6:40 PM, =D0=BB=B8=D9<xiegang112@gmail.com> w=
rote:
>>> On Tue, Sep 1, 2009 at 2:13 PM, Jonathan Nell<crtrn13@gmail.com> wr=
ote:
>>>> Is there any way to sniff the traffic of a scsi device? I need to
>>>> debug a firmware update and need to see the traffic being passed t=
o
>>>> the drive
>>> You may hook the queue_command function of the scsi host. It can sn=
iff
>>> all scsi request to scsi host driver.
>>> Thanks,
>>
>> I developed a tool to dump all the SCSI cmds to SCSI device. The ide=
a
>> is, every SCSI host controller driver should give the queue_command
>> fucntion. This is the entrance for SCSI request to SCSI host
>> controller driver. I replace this function with my own dump methord
>> and after dump, I restore this function.
>>
>> I do't know if it's what you need.
>
> That would be great! Could you send the code to me? How does your too=
l
> hook into queue_command?
The code could be found at
http://blog.chinaunix.net/u/15278/showart_1966962.html. You need do
some modification according your kernel.
It's very simple to hook the queue_command. I just backup the original
function pointer somewhere and after dump, I restore it. Pls refer the
code for detail.

Thanks,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



--=20
Xie Gang
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
