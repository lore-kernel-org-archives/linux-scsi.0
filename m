From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Remove #warnings for longstanding conditions.
Date: Thu, 25 Oct 2007 22:19:04 -0400
Message-ID: <47214E98.6070402@garzik.org>
References: <a576b5944eb04a18d4df3dd27cd32e7f13601470.1193299380.git.jeff@garzik.org> <03231528cf69b4194111178db23a7a387a573cb7.1193299380.git.jeff@garzik.org> <20071025112231.GL27248@parisc-linux.org> <47214BD5.4020106@garzik.org> <20071026021437.GQ27248@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39827 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758795AbXJZCTG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 22:19:06 -0400
In-Reply-To: <20071026021437.GQ27248@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>

Matthew Wilcox wrote:
> On Thu, Oct 25, 2007 at 10:07:17PM -0400, Jeff Garzik wrote:
>> Is this warning of value to anybody but you?
> 
> Yup.  It signals this driver isn't production quality yet.
> 
>> Is this information worth printing out on everyone else's kernel build?
> 
> I thnk that's worth noting to anyone who's enabled it.

OK, thanks!

	Jeff



