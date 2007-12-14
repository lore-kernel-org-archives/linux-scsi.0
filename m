From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] [SCSI] sym53c8xx: fix "irq X: nobody cared" regression in 2.6.24
Date: Fri, 14 Dec 2007 14:07:58 -0700
Message-ID: <20071214210758.GY26334@parisc-linux.org>
References: <4762EB5C.9080100@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:60279 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014AbXLNVIA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Dec 2007 16:08:00 -0500
Content-Disposition: inline
In-Reply-To: <4762EB5C.9080100@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On Fri, Dec 14, 2007 at 03:45:16PM -0500, Tony Battersby wrote:
> After this happens, the kernel disables the IRQ, causing the SCSI card
> to stop working until the next reboot.  The problem is caused by the
> interrupt handler returning IRQ_NONE instead of IRQ_HANDLED after
> handling an interrupt-on-the-fly (INTF) condition.  The following patch
> fixes the problem.
> 
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Acked-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
