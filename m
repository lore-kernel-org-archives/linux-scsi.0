From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] convert struct scsi_varlen_cdb_hdr in scsi.h to use
 __u8 for user space
Date: Sun, 29 Jun 2008 22:02:03 +0900
Message-ID: <20080629220206I.fujita.tomonori@lab.ntt.co.jp>
References: <20080629210323W.fujita.tomonori@lab.ntt.co.jp>
	<20080629124346.GJ14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54617 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754280AbYF2NCJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Jun 2008 09:02:09 -0400
In-Reply-To: <20080629124346.GJ14894@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Sun, 29 Jun 2008 06:43:46 -0600
Matthew Wilcox <matthew@wil.cx> wrote:

> 
> But we don't install anything in include/scsi to userspace:
> 
> $ cat include/Kbuild 
> header-y += asm-generic/
> header-y += linux/
> header-y += sound/
> header-y += mtd/
> header-y += rdma/
> header-y += video/
> 
> header-y += asm-$(ARCH)/

Yeah, we don't now but it had been exported to user space, I
guess.

People who still use it in user space should fix their problem. But
using __u8 doesn't hurt anyone. I just thought it would be a bit nicer
to do that.
