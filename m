From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer kernels
Date: Thu, 23 Apr 2015 09:27:39 -0700
Message-ID: <CAH_2GhdzoPYoongHXgU-GyFwq-7JJ_ac_6o0JgmmMi0qd_7eNw@mail.gmail.com>
References: <CAH_2GhdM7RgP0a2fYnY3yqb1T_LhGasmwBwsaF+yfCqRhXUikg@mail.gmail.com>
	<5538D30E.6090300@crashplan.pro>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:33385 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966153AbbDWQ1k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 12:27:40 -0400
Received: by wgin8 with SMTP id n8so24179564wgi.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2015 09:27:39 -0700 (PDT)
In-Reply-To: <5538D30E.6090300@crashplan.pro>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ceriel Jacobs <linux-scsi@crashplan.pro>
Cc: linux-scsi@vger.kernel.org

Oh!  Glad to see it was not just me suffering from this bug.  Still
running a patched 4.0.0 kernel through the SAS expander.  Everything
seems happy.

On Thu, Apr 23, 2015 at 4:10 AM, Ceriel Jacobs <linux-scsi@crashplan.pro> wrote:
> Your mvsas port expander bug might be related to bug# 81861
>
> https://bugzilla.kernel.org/show_bug.cgi?id=81861
>
> Adam Talbot schreef op 13-04-15 om 17:11:
>>
>> To make a very long debugging story short, I think there is an issues/bug
>> with the mvsas driver. It works, with older kernels, and breaks on
>> newer kernels.
>>
>> My Debian Jessie system was running great on a 3.18 kernel.  Changed
>> cases to a newer supermicro case with a SAS expander backplane (SAS933EL).
>> That
>> was the only hardware change.  Now, when ever I boot, the system kernel
>> panics.
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
>>
>> At this point I have two options:
>> Stick with the old kernel (yuck)
>> Buy a new card running a better supported chipset
>>
>> Any help would be greatly appreciated
>> Thanks
>> Adam
>>
>
