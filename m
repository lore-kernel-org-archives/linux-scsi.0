From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
Date: Tue, 14 May 2013 08:57:16 -0700
Message-ID: <51925EDC.2080307@linaro.org>
References: <5191EBA7.9010303@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56434 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889Ab3ENP5T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 May 2013 11:57:19 -0400
Received: by mail-pb0-f43.google.com with SMTP id md12so549643pbc.30
        for <linux-scsi@vger.kernel.org>; Tue, 14 May 2013 08:57:19 -0700 (PDT)
In-Reply-To: <5191EBA7.9010303@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, JBottomley@parallels.com, linux-scsi@vger.kernel.org

On 05/14/2013 12:45 AM, Gu Zheng wrote:
>  From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Date: Mon, 13 May 2013 15:45:24 +0900
> Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
>
> Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.

So, why is this useful/needed?

thanks
-john

