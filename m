From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 14/17] sym53c8xx: Get rid of IRQ_FMT and IRQ_PRM
Date: Tue, 9 Oct 2007 09:28:46 -0600
Message-ID: <20071009152846.GF13842@parisc-linux.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141153666-git-send-email-matthew@wil.cx> <4706A5C3.6000005@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:58413 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXJIP2r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Oct 2007 11:28:47 -0400
Content-Disposition: inline
In-Reply-To: <4706A5C3.6000005@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

On Fri, Oct 05, 2007 at 04:59:47PM -0400, Jeff Garzik wrote:
> NAK
> 
> The proper format string is '%u' because irq is unsigned

I'll change it to %u in the next revision.  However, I respectfully
decline your NAK as this was not a regression.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
