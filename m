From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 05 Apr 2018 11:56:06 +0200
Message-ID: <7fc01f67a561ce1fad676fc34c2249e7@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
 <3265889.eu5sbW8aRz@natalenko.name>
 <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

04.04.2018 23:25, Kees Cook wrote:
> Thanks for the report! I hope someone more familiar with sg_io() can
> help explain the changing buffer offset... :P

Also, FYI, I kept the server running with smartctl periodically invoked, 
and it was still triggering BUGs, however, I consider them to be more or 
less harmless until the server got stuck with high I/O wait this morning 
after next smartctl invocation. So, it isn't harmless, it seems…

It could be unrelated, of course, since the journal didn't give me any 
hint (or a stack trace) on what happened, thus I'll monitor how things 
behave without smartctl too.

Regards,
   Oleksandr
