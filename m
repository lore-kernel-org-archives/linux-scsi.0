From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH #upstream-fixes] libata: Add transport class for libata
Date: Wed, 20 Aug 2008 17:17:01 +0900
Message-ID: <48ABD2FD.8010802@kernel.org>
References: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <e7510f760808182131q1bd3aa4bp694ebff75b612995@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Gwendal Grignou <gwendal@google.com>
Cc: IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gwendal Grignou wrote:
>>From df84b33306569f8247f331fd67b0a7e7dfb47936 Mon Sep 17 00:00:00 2001
> From: Gwendal Grignou <gwendal@google.com>
> Date: Mon, 18 Aug 2008 14:02:09 -0700
> Subject: Add transport class for libata.
> 
> This patch adds objects for accessing libata objects from user space:
> - ata_port class: one per ATA port
> - ata_link class: one per ATA port or 15 for SATA Port Multiplier
> - ata_device class: up to 2 for PATA link, usually one for SATA.
> 
> Each object exports information from the corresponding data strucure.
> For instance, ata_device exports id, the cached identify output if
> the device is a disk, gscr register output if it is a PM.
> 
> More fields can be added later, like error counters and ATA specific
> statistics.

Ah... I'm not so sure about the class transport approach although I do
agree that sysfs hierarchy for libata is way overdue.  Hmmm... Can you
please explain the planned hierarchy and how you're gonna match lifetime
rules?  Because libata uses very different object lifetime rules from
the generic driver layer, it can get ugly at times and from a quick
glance I don't really think the problem has been addressed but I could
have just missed it.

Thanks.

-- 
tejun
