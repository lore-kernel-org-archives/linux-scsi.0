From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [Bug 121531] Adaptec 7805H SAS HBA (pm80xx): hangs when writing
 >80MB at once
Date: Fri, 8 Jul 2016 09:47:15 +0200
Message-ID: <CAD+HZHVwXeRok3WaaJy-bQSMPU9Zk_A-dxJwtHJg==BTMZp6wA@mail.gmail.com>
References: <bug-121531-11613@https.bugzilla.kernel.org/> <bug-121531-11613-HCS9sSYYzs@https.bugzilla.kernel.org/>
 <CAL7F=LdPLnGoq7pReB3Mv+FR6qEqMyfsR=CrNotQ7qQuqVxV0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:34665 "EHLO
	mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbcGHHrS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 03:47:18 -0400
Received: by mail-lf0-f66.google.com with SMTP id a10so2540248lfb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2016 00:47:17 -0700 (PDT)
In-Reply-To: <CAL7F=LdPLnGoq7pReB3Mv+FR6qEqMyfsR=CrNotQ7qQuqVxV0A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas G <gviswas@gmail.com>
Cc: bugzilla-daemon@bugzilla.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, viswas.g@microsemi.com

Hi Viswas,

Thanks for update.
Good to know MicroSemi is still working on it!

Could you update the Maintainer file about your guys working email address?

Regards,
Jack

2016-07-08 6:47 GMT+02:00 Viswas G <gviswas@gmail.com>:
> Patch set for pm80xx is pending for the last 3 quarters.
> We will submit those soon with all the buf fixes and  performance
> tuning changes.
>
> Regards,
> Viswas G
>
> On Thu, Jul 7, 2016 at 10:04 PM,  <bugzilla-daemon@bugzilla.kernel.org> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=121531
>>
>> --- Comment #14 from Jack Wang <xjtuwjp@gmail.com> ---
>> The changes are huge, hard to do it, without help from MicroSemi/PMCs side.
>> And I don't have hardware to test.
>>
>> I've asked developer from MicroSemi to upsteam their changes, but
>> sadly no reply.
>>
>> 2016-07-07 17:36 GMT+02:00  <bugzilla-daemon@bugzilla.kernel.org>:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=121531
>>>
>>> --- Comment #13 from Martin von Wittich <martin.von.wittich@iserv.eu> ---
>>> Yup, the Debian installation worked and seems to work fine so far. I manually
>>> installed the pm80xx-1.4.0-11068-debian64.deb package in the target system
>>> while I was still in the installer by chrooting to /target; then I added
>>> "pm80xx" to /etc/initramfs/modules (without that update-initramfs wouldn't add
>>> the pm80xx module, I'm not really sure why).
>>>
>>> After booting the system, I've succcessfully written ~500 GB of /dev/zero data
>>> into a file on an MD raid consisting of both of the disks. No error messages in
>>> the dmesg either.
>>>
>>> Can you include those missing changes into the official kernel, or how can we
>>> resolve this bug? We'll ask to the customer if we can keep the server for an
>>> additional two weeks for testing, so if you need me to test builds, let me
>>> know.
>>>
>>> --
>>> You are receiving this mail because:
>>> You are on the CC list for the bug.
>>
>> --
>> You are receiving this mail because:
>> You are the assignee for the bug.
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
