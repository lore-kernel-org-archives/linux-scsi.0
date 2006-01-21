From: Andrew Morton <akpm@osdl.org>
Subject: Re: OOM Killer killing whole system
Date: Fri, 20 Jan 2006 16:50:31 -0800
Message-ID: <20060120165031.7773d9c4.akpm@osdl.org>
References: <1137337516.11767.50.camel@localhost>
	<1137793685.11771.58.camel@localhost>
	<20060120145006.0a773262.akpm@osdl.org>
	<200601201819.58366.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:46520 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1750746AbWAUAsf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jan 2006 19:48:35 -0500
In-Reply-To: <200601201819.58366.chase.venters@clientec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: a.titov@host.bg, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Chase Venters <chase.venters@clientec.com> wrote:
>
> > Next time you reboot 2.6.15 on that machine can you please send the output
> > of `dmesg -s 1000000'?  You might have to set CONFIG_LOG_BUF_SHIFT=17 to
> > prevent it from being truncated.
> 
> Here's mine (attached).

Great, thanks.  That tells us all sorts of stuff about your setup.

For linux-scsi reference, Chase's /proc/slabinfo says:

scsi_cmd_cache    1547440 1547440    384   10    1 : tunables   54   27    8 : 
slabdata 154744 154744      0

> Curious - the -s... were you expecting the ring buffer 
> to exceed 16384?

It can sometimes be quite large.  I always say -s 1000000 to make sure
everything got there.

> I don't think my (boot time) buffer does.

It's compile-time configurable with CONFIG_LOG_BUF_SHIFT and boot-time
configurable with log_buf_len=n.
