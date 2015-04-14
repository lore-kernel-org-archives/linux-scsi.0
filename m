From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer kernels
Date: Tue, 14 Apr 2015 17:46:50 -0400
Message-ID: <CAAzz28gCdbhW25vAJb_+rJ1aYfTk4MU8LrxYrOJfgjoMCxtaoQ@mail.gmail.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	<1429046165.2209.54.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:34288 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbbDNVqv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Apr 2015 17:46:51 -0400
Received: by widjs5 with SMTP id js5so98241690wid.1
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2015 14:46:50 -0700 (PDT)
In-Reply-To: <1429046165.2209.54.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Adam Talbot <ajtalbot1@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Any chance you can capture a vmcore (kernel only pages), I will
provide an upload location.
Thanks
Laurence

On Tue, Apr 14, 2015 at 5:16 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Tue, 2015-04-14 at 14:03 -0700, Adam Talbot wrote:
>> To make a very long debugging story short, I think there is an issues/bug
>> with the mvsas driver. It works, with older kernels, and breaks on
>> newer kernels.
>>
>> My Debian Jessie system was running great on a 3.18 kernel.  Changed
>> cases to a newer supermicro case with a SAS expander backplane (SAS933EL).  That
>> was the only hardware change.  Now, when ever I boot, the system kernel panics.
>>
>> 3.2.65-1+deb7u2 works
>> 3.9.0 Gentoo CD works
>> 3.16+ all fail
>> Attached are 3 kernel panics on 3.16+ kernels.
>>
>> Motherboard is a Supermicro X8SIE, with a "Marvell Technology Group Ltd.
>> 88SE6440 SAS/SATA PCIe controller"
>>
>> Is this a known bug?
>
> Well, you're the only person that's reported it so far.
>
> I think based on the above is that your configuration is a single
> expander attached SATA device ... and if you move it to be non expander
> attached it works fine?
>
>> At this point I have two options:
>> Stick with the old kernel (yuck)
>> Buy a new card running a better supported chipset
>>
>> Any help would be greatly appreciated
>> Thanks
>
> You didn't specify: does 3.15 work?  At least the highest working kernel
> version would help me narrow down potential problems.
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
