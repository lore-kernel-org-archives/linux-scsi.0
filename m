From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] Kernel/time: Introduce a new timestamp function
 local_time_seconds()
Date: Wed, 15 May 2013 07:18:00 -0400
Message-ID: <1368616680.19370.4.camel@dabdike>
References: <5191EBA7.9010303@cn.fujitsu.com> <51925EDC.2080307@linaro.org>
	 <519301D8.2030502@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40633 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755975Ab3EOLSE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 May 2013 07:18:04 -0400
In-Reply-To: <519301D8.2030502@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: John Stultz <john.stultz@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Wed, 2013-05-15 at 11:32 +0800, Gu Zheng wrote:
> On 05/14/2013 11:57 PM, John Stultz wrote:
> 
> > On 05/14/2013 12:45 AM, Gu Zheng wrote:
> >>  From 18072c1c3506a7e37ee485307a2c343efe5af4d0 Mon Sep 17 00:00:00 2001
> >> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
> >> Date: Mon, 13 May 2013 15:45:24 +0900
> >> Subject: [PATCH 1/2] Kernel/time: Introduce a new timestamp function local_time_seconds()
> >>
> >> Introduce a new timestamp function local_time_seconds() to hide the conversion of system time in UTC to local time seconds.
> > 
> > So, why is this useful/needed?
> 
> Hi John,
>    There are some subsystems use local time seconds as a timestamp,
> such as scsi(refer
> to:http://www.spinics.net/lists/linux-scsi/msg66089.html),
> and so do many out-of-kernel-tree code I think.

I don't think the 3ware drivers, which are the only ones that do this
actually care.  I think jiffies to seconds would suit the event
timestamps equally well, so I don't really see a need to make this a
formal kernel export given that it's only a single driver family in the
entirety of the kernel.

James


