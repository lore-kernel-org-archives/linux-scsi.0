From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 10 Apr 2018 20:13:01 -0700
Message-ID: <CAGXu5j+ZmgfqdoT_zPZ4qLCdMfjaaGxRCyz8c8ecp=39zQfw2w@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
 <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
 <2679696.GDoj5zcZOu@natalenko.name> <CAGXu5jLG9ia+zBNcPt+q+BpJayoUuYwXitOgeHmh=7sPp-s87A@mail.gmail.com>
 <51a7e805058ef7f35b226cbbf0ccc4ff@natalenko.name> <CAGXu5jKRrdYjuyLSvc4k4mqttkM7zw-96poQ1GYqRRgPqZFOYQ@mail.gmail.com>
 <3d7b5a707e216e19eb3defe0586bfbc8@natalenko.name> <CAGXu5j+9BJcR63bsqQpqaKrvcgOpWyDzgpD-zRrf1qq7v=Z2CA@mail.gmail.com>
 <d53af006c314eb9d326bfb19b08e189b@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d53af006c314eb9d326bfb19b08e189b@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Apr 10, 2018 at 10:16 AM, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
> Hi, Kees, Paolo et al.
>
> 10.04.2018 08:53, Kees Cook wrote:
>>
>> Unfortunately I only had a single hang with no dumps. I haven't been
>> able to reproduce it since. :(
>
>
> For your convenience I've prepared a VM that contains a reproducer.

Awesome. :)

> Under the /root folder there is a reproducer script (reproducer.sh). It does
> trivial things like enabling sysrq, opening LUKS device, mounting a volume,
> running a background I/O (this is an important part, actually, since I
> wasn't able to trigger the issue without the background I/O) and, finally,
> running the smartctl in a loop. If you are lucky, within a minute or two
> you'll get the first warning followed shortly by subsequent bugs and I/O
> stall (htop is pre-installed for your convenience too).

Yup!

[   27.729498] Bad or missing usercopy whitelist? Kernel memory
exposure attempt detected from SLUB object 'scsi_sense_cache' (offset
76, size 22)!

I'll see about booting with my own kernels, etc, and try to narrow this down. :)

-Kees

-- 
Kees Cook
Pixel Security
