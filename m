From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: mpt2sas logged messages
Date: Thu, 20 Aug 2009 17:20:25 +0200
Message-ID: <ac3eb2510908200820w7fef021bj7e4078ef47aa5816@mail.gmail.com>
References: <4A8AAA26.9090706@redhat.com> <20090818132518.GA4418@kroah.com>
	<4A8AB3DC.4060805@redhat.com> <20090818145710.GA6064@kroah.com>
	<4A8ACE7C.5080501@redhat.com> <20090818164017.GA24305@kroah.com>
	<ac3eb2510908181137ne79d4d7he1731d240bca614c@mail.gmail.com>
	<4A8AF5E4.7000806@redhat.com> <ac3eb2510908191230r7687ba34k4b8f6987ffa97ab8@mail.gmail.com>
	<4A8D6929.7000407@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:44618 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbZHTPUk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:20:40 -0400
Received: by fxm17 with SMTP id 17so511941fxm.37
        for <linux-scsi@vger.kernel.org>; Thu, 20 Aug 2009 08:20:40 -0700 (PDT)
In-Reply-To: <4A8D6929.7000407@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, Tom Coughlan <coughlan@redhat.com>

On Thu, Aug 20, 2009 at 17:18, Ric Wheeler<rwheeler@redhat.com> wrote:
> On 08/19/2009 03:30 PM, Kay Sievers wrote:
>> On Tue, Aug 18, 2009 at 20:41, Ric Wheeler<rwheeler@redhat.com> =C2=A0=
wrote:
>>
>>> I think that we can reconfigure the storage to avoid this but will =
be
>>> happy
>>> to restore this configuration if you have something that you want t=
o test
>>> later on...
>>
>> This hopefully addresses the issue:
>>
>> http://git.kernel.org/?p=3Dlinux/hotplug/udev.git;a=3Dcommit;h=3D2ff=
c9cc1917b1bb6fe86881a94a47dce9aa15168
>>
>> Thanks,
>> Kay
>
> Hi Kay,
>
> This seems to resolve the issue on my test rig - no more "too long" e=
rror
> messages during boot.

Great! Thanks a lot for the testing, and letting us know. It's a
pleasure when things work like this.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
