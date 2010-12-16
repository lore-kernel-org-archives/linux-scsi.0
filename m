From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling,
  take#2
Date: Thu, 16 Dec 2010 18:00:04 +0100
Message-ID: <4D0A4594.6030704@kernel.dk>
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk> <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com> <4D0A4196.8040209@kernel.dk> <4D0A4231.2070402@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D0A4231.2070402@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz, James.Bottomley@hansenpartnership.com
List-Id: linux-scsi@vger.kernel.org

On 2010-12-16 17:45, Tejun Heo wrote:
> Hello,
> 
> On 12/16/2010 05:43 PM, Jens Axboe wrote:
>>>>> Kay, Jens, James, how does this look to you guys?
>>>>
>>>> I like the concept, this is probably what we should have done all along.
>>>> The user space method has been tried and failed. So I was mostly laying
>>>> it low waiting for feedback before integrating this.
>>>
>>> Yeah, it's nice stuff. Userspace works, but can not be made entirely
>>> safe. We have (rare) bugs we just can not fix otherwise than disabling
>>> polling.
>>>
>>>> Kay?
>>>
>>> I want it! :)
>>>
>>> If you merge it, let me know when you have a tree ready, so I can test
>>> the most recent version again.
>>
>> OK good, looks like we all agree... I'll queue it up in for-2.6.38
>> branch and update for-next to have all that stuff.
> 
> Heh, that was fast.  Anyways, James, it would be great if you can take
> a look at the sr/sd changes.  I think they're correct but that's kinda
> expected, so... :-)

One thing I noticed is that cdrom_check_events() needs an export.

-- 
Jens Axboe

