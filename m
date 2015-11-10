From: Timur Tabi <timur@codeaurora.org>
Subject: Re: [PATCH V2 2/3] scsi: fix compiler warning for sg
Date: Mon, 9 Nov 2015 21:26:47 -0600
Message-ID: <564163F7.2020109@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VdUBKr_XQ=2_5uSww71YVz+-Shmhg5hSe5KAoeshTtMYQ@mail.gmail.com>
 <564162AB.6080803@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <564162AB.6080803@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Sinan Kaya <okaya@codeaurora.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, cov@codeaurora.org, jcm@redhat.com, Andy Gross <agross@codeaurora.org>, linux-arm-msm@vger.kernel.org, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Sinan Kaya wrote:
>
> I created this patch back in March with an older version of the compiler
> and older kernel (3.19). I'm no longer able to reproduce this with this
> compiler and linux-next.
>
> Thread model: posix
> gcc version 4.8.3 20140401 (prerelease) (crosstool-NG
> linaro-1.13.1-4.8-2014.04 - Linaro GCC 4.8-2014.04)
>
> I'll drop this patch.

Are you sure the compiler handles the old macro correctly?  Maybe it's 
just quiescing the error message, but it's still broken?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the
Code Aurora Forum, hosted by The Linux Foundation.
