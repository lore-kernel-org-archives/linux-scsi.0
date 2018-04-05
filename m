From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 05 Apr 2018 16:33:56 +0200
Message-ID: <08e06234c81fac30ccff5a2695d02f2a@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
 <3265889.eu5sbW8aRz@natalenko.name>
 <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
 <7fc01f67a561ce1fad676fc34c2249e7@natalenko.name>
 <CAGXu5jKhiE512yQXp90M+Wie=8RkpMZT-Yi_9BgjfKwibP433g@mail.gmail.com>
 <dee9721a530576e667881d86bbec351b@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <dee9721a530576e667881d86bbec351b@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

05.04.2018 16:32, Oleksandr Natalenko wrote:
> "-hda sda.img -hdb sda.img"

"-hda sda.img -hdb sdb.img", of course, I don't pass the same disk twice 
☺
