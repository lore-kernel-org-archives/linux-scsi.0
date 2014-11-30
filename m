From: Laurence Oberman <oberman.l@gmail.com>
Subject: Re: Crash when copying from broken external hdd
Date: Sun, 30 Nov 2014 10:58:26 -0500
Message-ID: <CAAzz28gHzPSC+VsSeq56oWj-KByCqK0oqeG3N4HM3D1iX_z6uQ@mail.gmail.com>
References: <1417258323.9558.3.camel@gmail.com>
	<CAFLxGvwKwZh38+-is8dX6zOFAiz0gVo+Yio3B=2eiMqmGCZfqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvwKwZh38+-is8dX6zOFAiz0gVo+Yio3B=2eiMqmGCZfqA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Simon Danner <danner.simon@gmail.com>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

I need more of the stack if you have it, the screenshot is not attached.
Thanks
Laurence

On Sun, Nov 30, 2014 at 6:11 AM, Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> On Sat, Nov 29, 2014 at 11:52 AM, Simon Danner <danner.simon@gmail.com> wrote:
>> Hello,
>> i get the following crash after i try to copy files from a broken
>> external hdd to another external hdd.
>> It happens after a few minutes, with latest git and 3.17.4 from Arch.
>> Attached screenshot is from latest mainline git.
>>
>> i hope this can be fixed somehow,
>> Regards Simon Danner
>
> Can you decode scsi_requed_end+0x122?
> CC'ing block and scsi folks.
>
> --
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
