From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 3/4] scsi: fix compiler warning for sg
Date: Thu, 5 Nov 2015 15:16:26 -0500
Message-ID: <563BB91A.6060502@codeaurora.org>
References: <1446698789-19308-1-git-send-email-okaya@codeaurora.org>
 <1446698789-19308-3-git-send-email-okaya@codeaurora.org>
 <CAHp75VfB1ToEZXRbxeWkU7xsWJkMz3v3A1O5QsH9LiiV4Be-iw@mail.gmail.com>
 <563B7180.2000405@codeaurora.org>
 <CAHp75VeVW3KRmCAa0mE4vPVus4Y9iFf0_PhV+kbvUziDWgTaOw@mail.gmail.com>
 <563BA0B3.6080506@codeaurora.org>
 <CAHp75Vfx0eCtP4H9kMPxy4g6UQM5jnBjJ43xnenn+h3N6uyvag@mail.gmail.com>
 <CAHp75VdaeGZ-cD6j4cUc_wdGnGYN2_x6vqua3Xrt2Fi8MGH+tQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdaeGZ-cD6j4cUc_wdGnGYN2_x6vqua3Xrt2Fi8MGH+tQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, timur@codeaurora.org, cov@codeaurora.org, jcm@redhat.com, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On 11/5/2015 2:56 PM, Andy Shevchenko wrote:
> One more look to the users of MULDIV.
>
> They all seems 32 bit for x.
> It means you don't need two do_div()s at all.
>
> Just do something like:
>
> u64 d = x * numer;
> do_div(d, denom);
> return d;

OK. I assume you want a change only in this file.

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
