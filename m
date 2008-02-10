From: Russell King <rmk+lkml@arm.linux.org.uk>
Subject: Re: scsi/arm/fas216.c compile error
Date: Sun, 10 Feb 2008 13:58:52 +0000
Message-ID: <20080210135851.GB25703@flint.arm.linux.org.uk>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi> <47AEF6FD.8080801@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54136 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYBJN7X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Feb 2008 08:59:23 -0500
Content-Disposition: inline
In-Reply-To: <47AEF6FD.8080801@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Adrian Bunk <adrian.bunk@movial.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Feb 10, 2008 at 03:07:09PM +0200, Boaz Harrosh wrote:
> It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
>   [SCSI] arm: convert to accessors and !use_sg cleanup
> 
> Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
> to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
> we finally managed a Tested-by:.
> 
> I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
> schedule.

Oh, I was ill for most of December, particularly at the time that you
sent the patch, and by the time I recovered, it was buried in my mailbox.

Suggest you have some consideration for others who might not be able to
do your beg and call at the immediate moment that you want it, and
consider that their email management skills may not be as l33t as yours.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
