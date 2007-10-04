From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Wed, 03 Oct 2007 23:27:37 -0400
Message-ID: <47045DA9.20907@garzik.org>
References: <20071003.151729.95504687.davem@davemloft.net>	 <189434.76759.qm@web31810.mail.mud.yahoo.com> <7579f7fb0710032023x6773075ga0342033e8f6f3a4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:42976 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047AbXJDD1n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 23:27:43 -0400
In-Reply-To: <7579f7fb0710032023x6773075ga0342033e8f6f3a4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Jacob <lydianconcepts@gmail.com>
Cc: ltuikov@yahoo.com, David Miller <davem@davemloft.net>, mdr@sgi.com, James.Smart@emulex.com, linux-scsi@vger.kernel.org

Matthew Jacob wrote:
> A much better choice is to get real stamped serial number WWNs. I also
> hold with some of the other folks on this discussion that some of this
> is policy that the admin should be allowed to choose. After they've
> segmented the company's main fabric by choosing unwisely and
> forgetting to practice safe zoning we'll choose to buy them a drink or
> two.

hehe :)

Let's not forget, too, that this entire thread is talking about the 1% case.

The common case everybody agrees on -- the manufacturer should provide a 
unique WWN for each board etc.  That's the 99% case.  And just like 
ethernet NICs, the system works as intended /most of the time/.

	Jeff


