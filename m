From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Update to ide-scsi error handling
Date: 10 Mar 2003 23:41:25 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1047339684.16969.9.camel@irongate.swansea.linux.org.uk>
References: <20030126205831.GM24610@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030126205831.GM24610@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: wrlk@riede.org
Cc: linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, 2003-01-26 at 20:58, Willem Riede wrote:
> One of my ATAPI drives developed a real dislike to 2.5.55 and above, which gave
> me plenty of opportunity to improve ide-scsi's error handling :-) .

Cool. I've rewritten the do_reset logic in the 2.5.64-ac code so that it
has a few less races

> To handle ide device resets and be able to wait for them in the scsi context, I 
> have changed ide_do_reset and friends in drivers/ide/ide-iops.c to set the busy 
> flag on the hwgroup while the reset is in progress.

Duplicated work, but I'm kind of happy because we both agreed on that
part of the solution being safe 8)

> I noticed, that ide-scsi didn't consistently use the printk priorities, so I
> touched that up while I was at it.

Thanks


