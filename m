From: Richard Weinberger <richard@nod.at>
Subject: Re: Crash when copying from broken external hdd
Date: Sun, 30 Nov 2014 17:42:27 +0100
Message-ID: <547B48F3.6020909@nod.at>
References: <1417258323.9558.3.camel@gmail.com>	 <CAFLxGvwKwZh38+-is8dX6zOFAiz0gVo+Yio3B=2eiMqmGCZfqA@mail.gmail.com>	 <CAAzz28gHzPSC+VsSeq56oWj-KByCqK0oqeG3N4HM3D1iX_z6uQ@mail.gmail.com> <1417365364.4806.1.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417365364.4806.1.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Danner <danner.simon@gmail.com>, Laurence Oberman <oberman.l@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Am 30.11.2014 um 17:36 schrieb Simon Danner:
> Hi,
> here the two screenshots i could take, from 3.17.4 and 3.18 git.

You're hitting BUG_ON(blk_queued_rq(req)); in blk_finish_request()

Thanks,
//richard

> Thanks
> Simon
> 
> On Sun, 2014-11-30 at 10:58 -0500, Laurence Oberman wrote:
>> I need more of the stack if you have it, the screenshot is not attached.
>> Thanks
>> Laurence
>>
>> On Sun, Nov 30, 2014 at 6:11 AM, Richard Weinberger
>> <richard.weinberger@gmail.com> wrote:
>>> On Sat, Nov 29, 2014 at 11:52 AM, Simon Danner <danner.simon@gmail.com> wrote:
>>>> Hello,
>>>> i get the following crash after i try to copy files from a broken
>>>> external hdd to another external hdd.
>>>> It happens after a few minutes, with latest git and 3.17.4 from Arch.
>>>> Attached screenshot is from latest mainline git.
>>>>
>>>> i hope this can be fixed somehow,
>>>> Regards Simon Danner
>>>
>>> Can you decode scsi_requed_end+0x122?
>>> CC'ing block and scsi folks.
>>>
>>> --
>>> Thanks,
>>> //richard
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
