From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer kernels
Date: Thu, 16 Apr 2015 10:31:43 -0700
Message-ID: <CAH_2Ghfva5b3igBN8XQRP8h0Vr4Mo0_SCNtGpJHFz-uV_oDEoA@mail.gmail.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	<1429046165.2209.54.camel@HansenPartnership.com>
	<CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
	<1429161361.2608.4.camel@HansenPartnership.com>
	<CAH_2GhdsUqjmG4V-9X5QRkwNiVg9O5qp9Hpskis39qy=dmgYyA@mail.gmail.com>
	<1429205296.2196.22.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37144 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbbDPRbp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 13:31:45 -0400
Received: by widdi4 with SMTP id di4so106049983wid.0
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2015 10:31:44 -0700 (PDT)
In-Reply-To: <1429205296.2196.22.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org

Oh! Good idea. ;-)
I will test it in 6~8 hours, once the raid check finishes.

On Thu, Apr 16, 2015 at 10:28 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Thu, 2015-04-16 at 10:26 -0700, Adam Talbot wrote:
>> Wow, I forgot how long it takes to compile a full kernel.  Glad I ran
>> Gentoo for a few years and knew how to compile and apply patches. I
>> will admit I had to dust off some mental cobwebs.
>>
>> Pre-patched 4.0.0 kernel tree: Oops, as expected
>> Patched 4.0.0 kernel tree: IT WORKED!!!!!  Basic mount, and checking a
>> few files all looks good.  I will start a RAID check as that should
>> really push the driver. I will report back tomorrow when it finishes.
>
> Could you also check the direct ATA attachment case to make sure I
> didn't screw that up.  The fix is based on a theory about how the driver
> operates rather than any actual documentation.
>
> Thanks,
>
> James
>
>
