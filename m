From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCHSET] block/SCSI: implement in-kernel disk event handling, take#2
Date: Thu, 16 Dec 2010 17:41:42 +0100
Message-ID: <AANLkTi=d78R=1=7Ngm-CVLS9xTU-U0BojVi9fS5z5hr8@mail.gmail.com>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
 <4D0A3EE1.4050404@kernel.org> <4D0A400F.5090608@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D0A400F.5090608@kernel.dk>
Sender: linux-ide-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jack@suse.cz, James.Bottomley@hansenpartnership.com
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 16, 2010 at 17:36, Jens Axboe <axboe@kernel.dk> wrote:
> On 2010-12-16 17:31, Tejun Heo wrote:
>> On 12/08/2010 08:57 PM, Tejun Heo wrote:
>>> This is the second take of in-kernel-disk-event patchset which
>>> implements in-kernel disk event handling framework and adds support
>>> for it to sr and sd. =C2=A0This is largely to move media presence p=
olling
>>> into kernel as userspace implementation turned out to be quite
>>> problematic over the years.
>>
>> Kay, Jens, James, how does this look to you guys?
>
> I like the concept, this is probably what we should have done all alo=
ng.
> The user space method has been tried and failed. So I was mostly layi=
ng
> it low waiting for feedback before integrating this.

Yeah, it's nice stuff. Userspace works, but can not be made entirely
safe. We have (rare) bugs we just can not fix otherwise than disabling
polling.

> Kay?

I want it! :)

If you merge it, let me know when you have a tree ready, so I can test
the most recent version again.

Thanks,
Kay
