From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH V2 2/3] scsi: fix compiler warning for sg
Date: Tue, 10 Nov 2015 11:23:42 +0200
Message-ID: <CAHp75Veg7FmxYD7oLuE9ZsvFmOvvaxC5ooB2fgdQHfiTJCw0vg@mail.gmail.com>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
	<1447034266-28003-3-git-send-email-okaya@codeaurora.org>
	<CAHp75VdUBKr_XQ=2_5uSww71YVz+-Shmhg5hSe5KAoeshTtMYQ@mail.gmail.com>
	<564162AB.6080803@codeaurora.org>
	<564163F7.2020109@codeaurora.org>
	<564177D7.7070103@codeaurora.org>
	<5641783D.3030108@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5641783D.3030108@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Timur Tabi <timur@codeaurora.org>
Cc: Sinan Kaya <okaya@codeaurora.org>, linux-scsi <linux-scsi@vger.kernel.org>, cov@codeaurora.org, jcm@redhat.com, Andy Gross <agross@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 10, 2015 at 6:53 AM, Timur Tabi <timur@codeaurora.org> wrote:
> Sinan Kaya wrote:
>>
>>
>> The code says it is using these macros for small integers only which
>> can't overflow. I was trying to get rid of compiler warning and it seems
>> to have disappeared.
>
>
> I would double-check the assembly code, if I were you.  I don't like it when
> warnings just go away like that.

+1 to that.

>
> Besides, we *should* be using do_div() for 64-bit division.

But here looks like all numbers are guaranteed to be less than or
equal to INT_MAX.
Thus, the matter is only to replace MULDIV() by mult_frac() which is
already in kernel.

-- 
With Best Regards,
Andy Shevchenko
