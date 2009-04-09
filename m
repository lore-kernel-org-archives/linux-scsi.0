From: Alexander Beregalov <a.beregalov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: 2.6.30-rc1 cannot boot: scsi/async
Date: Thu, 9 Apr 2009 17:00:57 +0400
Message-ID: <a4423d670904090600w7286ec0elda3c608b740281ea@mail.gmail.com>
References: <a4423d670904081012j30ad104etefeee0c8c682aca9@mail.gmail.com>
	 <19f34abd0904081015r5549da00w97593be16373bb8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <19f34abd0904081015r5549da00w97593be16373bb8c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: kernel-testers-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vegard Nossum <vegard.nossum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Testers List <kernel-testers-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

2009/4/8 Vegard Nossum <vegard.nossum-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> 2009/4/8 Alexander Beregalov <a.beregalov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> Hi
>>
>> It is 2*2 SMP system, x86_64.
>>
>> INFO: task async/0:1073 blocked for more than 120 seconds.
>
>
> Hi,
>
> I just proposed a patch to fix this:
>
> http://marc.info/?l=linux-kernel&m=123920746830420&w=2
>
> Don't know if it's correct or whether it actually fixes the problem,
> but you are welcome to try it :-)

It works for me as well. Thanks.
