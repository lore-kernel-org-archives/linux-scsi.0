From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: Recent removal of bsg read/write support
Date: Sun, 2 Sep 2018 13:44:31 +0200
Message-ID: <CAFLxGvxX8QW4wUJKommXVMpGBj7G_H3=SOwQGjGuyPZZrhCzKw@mail.gmail.com>
References: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOuWhkaGjX8Q_xghkFVTqzZkDrUv-sdH=VbS7hvnqFWrT+3eOQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: drorl@infinidat.com
Cc: LKML <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

CC'ing relevant people. Otherwise your mail might get lost.

On Sun, Sep 2, 2018 at 1:37 PM Dror Levin <drorl@infinidat.com> wrote:
>
> Note: I am not subscribed to LKML so please CC replies to this email.
>
> Hi,
>
> We have an internal tool that uses the bsg read/write interface to
> issue SCSI commands as part of a test suite for a storage device.
>
> After recently reading on LWN that this interface is to be removed we
> tried porting our code to use sg instead. However, that raises new
> issues - mainly getting ENOMEM over iSCSI for unknown reasons.
>
> Because of this we would like to continue using the bsg interface,
> even if some changes are required to meet security concerns.
>
> Is there any chance for this removal to be reverted? I saw it was
> already included in 4.19-rc1.
>
> Regards,
> Dror



-- 
Thanks,
//richard
