From: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
Date: Fri, 24 Sep 2010 03:58:13 +0200
Message-ID: <1285293493.17998.2.camel@maxim-laptop>
References: <4C9BE5A8.1090002@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4C9BE5A8.1090002@teksavvy.com>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2010-09-23 at 19:41 -0400, Mark Lord wrote:
> What's the purpose of this stack dump,
> and how can it be prevented in this NORMAL situation??
> 
> The command was "hdparm --security-erase NULL /dev/sdb",
> which takes about 66 minutes to complete on this particular drive.
> 
> I don't see any obvious way for the task to mark itself
> as needing longer than 120 secs to complete the operation.

There is other valid user case.
If application calls sys_sync and at same time the filesystem is written
by an other application, the sync can easily take more that 2 minutes.
Or if block device is slow (as it was with some flash cards).

Indeed it would be good to have a kind of touch_softlockup_watchdog().

Best regards,
	Maxim Levitsky

