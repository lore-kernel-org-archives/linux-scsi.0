From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] 3w-xxxx: remove unnecessary local_irq_save/restore for
 scsi sg copy API
Date: Sat, 11 Oct 2008 16:00:03 +0900
Message-ID: <20081011160001X.fujita.tomonori@lab.ntt.co.jp>
References: <20081009112510D.fujita.tomonori@lab.ntt.co.jp>
	<b1bc6a000810101243n59644f4cqfdc8b702ece2c765@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:36193 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762307AbYJKHAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Oct 2008 03:00:30 -0400
In-Reply-To: <b1bc6a000810101243n59644f4cqfdc8b702ece2c765@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: aradford@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, linuxraid@amcc.com

On Fri, 10 Oct 2008 12:43:09 -0700
"adam radford" <aradford@gmail.com> wrote:

> On Wed, Oct 8, 2008 at 7:25 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> > Since the commit 50bed2e2862a8f3a4f7d683d0d27292e71ef18b9 (sg: disable
> > interrupts inside sg_ncopy_buffer), no need to disable interrupts
> > before calling scsi_sg_copy_from_buffer. So we can simplify
> > tw_transfer_internal, which disables interrupts just for
> > scsi_sg_copy_from_buffer.
> 
> Thanks for the patch.  Looks like we will need a similar one for the 3w-9xxx
> driver.

Oops, I overlooked it. Yeah, we can simplify 3w-9xxx a bit too. I've
just sent a similar patch for 3w-9xxx.

Thanks,
