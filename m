From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 14/17] sym53c8xx: Get rid of IRQ_FMT and IRQ_PRM
Date: Tue, 09 Oct 2007 11:35:14 -0400
Message-ID: <470B9FB2.9010300@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141153666-git-send-email-matthew@wil.cx> <4706A5C3.6000005@garzik.org> <20071009152846.GF13842@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47446 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267AbXJIPfX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Oct 2007 11:35:23 -0400
In-Reply-To: <20071009152846.GF13842@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> On Fri, Oct 05, 2007 at 04:59:47PM -0400, Jeff Garzik wrote:
>> NAK
>>
>> The proper format string is '%u' because irq is unsigned
> 
> I'll change it to %u in the next revision.  However, I respectfully
> decline your NAK as this was not a regression.

Not true.  The original code used 'int irq', and the printf format was 
correct as a result.

You changed the code to use 'unsigned int irq' as found in struct 
pci_dev, without changing IRQ_FMT as needed.

If you wanted to avoid the regression another way, I suppose patch #1 
should update IRQ_FMT to use "%u", and patch #14 should move the "%u" 
use to its caller.

	Jeff



