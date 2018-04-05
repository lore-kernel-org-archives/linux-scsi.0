From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 5 Apr 2018 11:52:31 -0700
Message-ID: <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
 <3265889.eu5sbW8aRz@natalenko.name> <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
 <7fc01f67a561ce1fad676fc34c2249e7@natalenko.name> <CAGXu5jKhiE512yQXp90M+Wie=8RkpMZT-Yi_9BgjfKwibP433g@mail.gmail.com>
 <dee9721a530576e667881d86bbec351b@natalenko.name> <08e06234c81fac30ccff5a2695d02f2a@natalenko.name>
 <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

[forcing non-HTML and resending...]

On Thu, Apr 5, 2018 at 7:33 AM, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
>
> 05.04.2018 16:32, Oleksandr Natalenko wrote:
>>
>> "-hda sda.img -hdb sda.img"
>
>
> "-hda sda.img -hdb sdb.img", of course, I don't pass the same disk twice

Okay. My qemu gets mad about that and wants the format=raw argument,
so I'm using:

-drive file=sda.img,format=raw \
-drive file=sdb.img,format=raw \

How are you running your smartctl? I'm doing this now:

[1]   Running                 while :; do
    ( smartctl -a /dev/sda; smartctl -a /dev/sdb ) > /dev/null;
done &

I assume I'm missing something from your .config, but since I don't
boot with an initramfs, I had to tweak it a bit. I'll try again...

-Kees

-- 
Kees Cook
Pixel Security
