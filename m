From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: Crash when copying from broken external hdd
Date: Sun, 30 Nov 2014 12:11:57 +0100
Message-ID: <CAFLxGvwKwZh38+-is8dX6zOFAiz0gVo+Yio3B=2eiMqmGCZfqA@mail.gmail.com>
References: <1417258323.9558.3.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417258323.9558.3.camel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Simon Danner <danner.simon@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Nov 29, 2014 at 11:52 AM, Simon Danner <danner.simon@gmail.com> wrote:
> Hello,
> i get the following crash after i try to copy files from a broken
> external hdd to another external hdd.
> It happens after a few minutes, with latest git and 3.17.4 from Arch.
> Attached screenshot is from latest mainline git.
>
> i hope this can be fixed somehow,
> Regards Simon Danner

Can you decode scsi_requed_end+0x122?
CC'ing block and scsi folks.

-- 
Thanks,
//richard
