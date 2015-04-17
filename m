From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer kernels
Date: Thu, 16 Apr 2015 19:26:05 -0700
Message-ID: <CAH_2GhexZPo=oisjmv=7vcFoA9XnzkmGO+C7bPkjigjksy832A@mail.gmail.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	<1429046165.2209.54.camel@HansenPartnership.com>
	<CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
	<1429161361.2608.4.camel@HansenPartnership.com>
	<CAH_2GhdsUqjmG4V-9X5QRkwNiVg9O5qp9Hpskis39qy=dmgYyA@mail.gmail.com>
	<1429205296.2196.22.camel@HansenPartnership.com>
	<CAH_2Ghfva5b3igBN8XQRP8h0Vr4Mo0_SCNtGpJHFz-uV_oDEoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:37752 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbDQC0G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 22:26:06 -0400
Received: by widdi4 with SMTP id di4so5319657wid.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2015 19:26:05 -0700 (PDT)
In-Reply-To: <CAH_2Ghfva5b3igBN8XQRP8h0Vr4Mo0_SCNtGpJHFz-uV_oDEoA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Tested against main RAID6, 7 disk array, with sas extender and work
with out error.
Tested against 2X mirror of SSD's, direct attached, and worked with out error.

Check was a simple RAID check.  "echo check > /sys/block/md126/md/sync_action"

Patched against:
root@nas:~# uname -a
Linux nas 4.0.0 #1 SMP Thu Apr 16 09:05:59 PDT 2015 x86_64 GNU/Linux

Many thanks to all involved in helping me debug this.
Should this patch be tested by a few other then added to the kernel tree?

On Thu, Apr 16, 2015 at 10:31 AM, Adam Talbot <ajtalbot1@gmail.com> wrote:
> Oh! Good idea. ;-)
> I will test it in 6~8 hours, once the raid check finishes.
>
> On Thu, Apr 16, 2015 at 10:28 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
>> On Thu, 2015-04-16 at 10:26 -0700, Adam Talbot wrote:
>>> Wow, I forgot how long it takes to compile a full kernel.  Glad I ran
>>> Gentoo for a few years and knew how to compile and apply patches. I
>>> will admit I had to dust off some mental cobwebs.
>>>
>>> Pre-patched 4.0.0 kernel tree: Oops, as expected
>>> Patched 4.0.0 kernel tree: IT WORKED!!!!!  Basic mount, and checking a
>>> few files all looks good.  I will start a RAID check as that should
>>> really push the driver. I will report back tomorrow when it finishes.
>>
>> Could you also check the direct ATA attachment case to make sure I
>> didn't screw that up.  The fix is based on a theory about how the driver
>> operates rather than any actual documentation.
>>
>> Thanks,
>>
>> James
>>
>>
