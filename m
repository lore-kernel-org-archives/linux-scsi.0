From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
Date: Thu, 25 Oct 2007 22:07:17 -0400
Message-ID: <47214BD5.4020106@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org> <20071025112231.GL27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:33579 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbXJZCHT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 22:07:19 -0400
In-Reply-To: <20071025112231.GL27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>

Matthew Wilcox wrote:

>> drivers/scsi/advansys.c:71:2: warning: #warning this driver is still
>> not properly converted to the DMA API

> I'll be removing this #warning from advansys when I get rid of the
> last bus_to_virt.  Which I've already done ... it's just that the
> resulting driver works on i386, but crashes parisc, so there's clearly a
> bug.  I haven't had time to track it down yet.  So NACK this patch.

Well, two main questions...

Is this warning of value to anybody but you?
Is this information worth printing out on everyone else's kernel build?

If yes, great!  But it sounds like this warning is analagous to

   #warning willy's TODO list: get milk, buy groceries, read email, ...

which doesn't add much value to others' kernel builds :)

	Jeff


