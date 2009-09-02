From: Jonathan Nell <crtrn13@gmail.com>
Subject: Re: scsi traffic sniffing
Date: Wed, 2 Sep 2009 07:20:28 +0300
Message-ID: <48e952f40909012120y1d56bb6bha18330fa3266ed64@mail.gmail.com>
References: <48e952f40908312312w7765c2a1q3a4f022967735288@mail.gmail.com>
	 <48e952f40908312313u75e4d00cr3d934f1dbdd1cca9@mail.gmail.com>
	 <48e952f40908312313y372d5009mc0197dff49d3b778@mail.gmail.com>
	 <d364733c0909010340t57499a38y4c0bd949e5ba63a6@mail.gmail.com>
	 <d364733c0909012012s1c75434au6a2230e07af4241c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:48851 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbZIBEU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 00:20:26 -0400
Received: by fxm17 with SMTP id 17so523727fxm.37
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2009 21:20:28 -0700 (PDT)
In-Reply-To: <d364733c0909012012s1c75434au6a2230e07af4241c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

2009/9/2 =D0=BB=B8=D9 <xiegang112@gmail.com>:
> On Tue, Sep 1, 2009 at 6:40 PM, =D0=BB=B8=D9<xiegang112@gmail.com> wr=
ote:
>> On Tue, Sep 1, 2009 at 2:13 PM, Jonathan Nell<crtrn13@gmail.com> wro=
te:
>>> Is there any way to sniff the traffic of a scsi device? I need to
>>> debug a firmware update and need to see the traffic being passed to
>>> the drive
>> You may hook the queue_command function of the scsi host. It can sni=
ff
>> all scsi request to scsi host driver.
>> Thanks,
>
> I developed a tool to dump all the SCSI cmds to SCSI device. The idea
> is, every SCSI host controller driver should give the queue_command
> fucntion. This is the entrance for SCSI request to SCSI host
> controller driver. I replace this function with my own dump methord
> and after dump, I restore this function.
>
> I do't know if it's what you need.

That would be great! Could you send the code to me? How does your tool
hook into queue_command?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
