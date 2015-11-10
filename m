From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH V2 2/3] scsi: fix compiler warning for sg
Date: Mon, 9 Nov 2015 22:21:15 -0500
Message-ID: <564162AB.6080803@codeaurora.org>
References: <1447034266-28003-1-git-send-email-okaya@codeaurora.org>
 <1447034266-28003-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VdUBKr_XQ=2_5uSww71YVz+-Shmhg5hSe5KAoeshTtMYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAHp75VdUBKr_XQ=2_5uSww71YVz+-Shmhg5hSe5KAoeshTtMYQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, timur@codeaurora.org, Andy Gross <agross@codeaurora.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, cov@codeaurora.org, jcm@redhat.com, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org



On 11/9/2015 9:14 AM, Andy Shevchenko wrote:
> Parens are useless, noticed later, sorry.
>
> Isn't mult_frac() enough here?
>
> Btw, can you mention explicitly what is the warning you get
> (copy'n'paste of the line would be okay)?

I created this patch back in March with an older version of the compiler 
and older kernel (3.19). I'm no longer able to reproduce this with this 
compiler and linux-next.

Thread model: posix
gcc version 4.8.3 20140401 (prerelease) (crosstool-NG 
linaro-1.13.1-4.8-2014.04 - Linaro GCC 4.8-2014.04)

I'll drop this patch.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
