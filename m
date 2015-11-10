From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH V2 2/3] scsi: fix compiler warning for sg
Date: Mon, 9 Nov 2015 22:53:17 -0600
Message-ID: <5641783D.3030108@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VdUBKr_XQ=2_5uSww71YVz+-Shmhg5hSe5KAoeshTtMYQ@mail.gmail.com>
 <564162AB.6080803@codeaurora.org> <564163F7.2020109@codeaurora.org>
 <564177D7.7070103@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <564177D7.7070103@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, cov@codeaurora.org, jcm@redhat.com, Andy Gross <agross@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sinan Kaya wrote:
>
> The code says it is using these macros for small integers only which
> can't overflow. I was trying to get rid of compiler warning and it seems
> to have disappeared.

I would double-check the assembly code, if I were you.  I don't like it 
when warnings just go away like that.

Besides, we *should* be using do_div() for 64-bit division.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
