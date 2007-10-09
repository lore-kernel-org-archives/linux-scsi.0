From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 14/17] sym53c8xx: Get rid of IRQ_FMT and IRQ_PRM
Date: Tue, 9 Oct 2007 09:44:14 -0600
Message-ID: <20071009154413.GH13842@parisc-linux.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141153666-git-send-email-matthew@wil.cx> <4706A5C3.6000005@garzik.org> <20071009152846.GF13842@parisc-linux.org> <470B9FB2.9010300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:42671 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbXJIPoO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 11:44:14 -0400
Content-Disposition: inline
In-Reply-To: <470B9FB2.9010300@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Tue, Oct 09, 2007 at 11:35:14AM -0400, Jeff Garzik wrote:
> Not true.  The original code used 'int irq', and the printf format was 
> correct as a result.
> 
> You changed the code to use 'unsigned int irq' as found in struct 
> pci_dev, without changing IRQ_FMT as needed.
> 
> If you wanted to avoid the regression another way, I suppose patch #1 
> should update IRQ_FMT to use "%u", and patch #14 should move the "%u" 
> use to its caller.

What do you think the regression is, exactly?

The *only* difference in how vsnprintf handles %d vs %u is the sign bit.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
