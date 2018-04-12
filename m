From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 11 Apr 2018 17:03:38 -0700
Message-ID: <CAGXu5j+-PNYxSc3v+QtQLK0S3wdtFthFSxNM_69kFDnPQX0Gaw@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
 <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
 <2679696.GDoj5zcZOu@natalenko.name> <CAGXu5jLG9ia+zBNcPt+q+BpJayoUuYwXitOgeHmh=7sPp-s87A@mail.gmail.com>
 <51a7e805058ef7f35b226cbbf0ccc4ff@natalenko.name> <CAGXu5jKRrdYjuyLSvc4k4mqttkM7zw-96poQ1GYqRRgPqZFOYQ@mail.gmail.com>
 <3d7b5a707e216e19eb3defe0586bfbc8@natalenko.name> <CAGXu5j+9BJcR63bsqQpqaKrvcgOpWyDzgpD-zRrf1qq7v=Z2CA@mail.gmail.com>
 <d53af006c314eb9d326bfb19b08e189b@natalenko.name> <CAGXu5j+ZmgfqdoT_zPZ4qLCdMfjaaGxRCyz8c8ecp=39zQfw2w@mail.gmail.com>
 <CAGXu5jL82QYuJi64EMKsczqBysUY8ZBssWWaY0LfNA1a0orY8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL82QYuJi64EMKsczqBysUY8ZBssWWaY0LfNA1a0orY8A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 11, 2018 at 3:47 PM, Kees Cook <keescook@chromium.org> wrote:
> On Tue, Apr 10, 2018 at 8:13 PM, Kees Cook <keescook@chromium.org> wrote:
>> I'll see about booting with my own kernels, etc, and try to narrow this down. :)
>
> If I boot kernels I've built, I no longer hit the bug in this VM
> (though I'll keep trying). What compiler are you using?

Ignore that: I've reproduced it with my kernels now. I think I messed
up the initramfs initially. But with an exact copy of your .config,
booting under Arch grub with initramfs, I see it. I'll start removing
variables now... :P

-Kees

-- 
Kees Cook
Pixel Security
