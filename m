From: Gu Zheng <guz.fnst@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
Date: Wed, 15 May 2013 11:32:40 +0800
Message-ID: <519301D8.2030502@cn.fujitsu.com>
References: <5191EBA7.9010303@cn.fujitsu.com> <51925EDC.2080307@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <51925EDC.2080307@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: John Stultz <john.stultz@linaro.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/14/2013 11:57 PM, John Stultz wrote:

> On 05/14/2013 12:45 AM, Gu Zheng wrote:
>>  From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
>> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Date: Mon, 13 May 2013 15:45:24 +0900
>> Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
>>
>> Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.
> 
> So, why is this useful/needed?

Hi John,
   There are some subsystems use local time seconds as a timestamp, such as scsi(refer to:http://www.spinics.net/lists/linux-scsi/msg66089.html),
and so do many out-of-kernel-tree code I think.

Best regards,
Gu

> 
> thanks
> -john
> 
> 
