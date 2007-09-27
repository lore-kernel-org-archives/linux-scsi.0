From: Jeff Garzik <jeff@garzik.org>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 10:19:23 -0400
Message-ID: <46FBBBEB.4020605@garzik.org>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53649 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbXI0OT0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Sep 2007 10:19:26 -0400
In-Reply-To: <46FBB86B.8000206@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Smart wrote:
> Uh, although this may work very well for small constrained configs, as one
> who debugs larger environments (and things always grow or get connected in
> ways you don't expect), depending on a random number for uniqueness makes
> me very unsettled. Debugging that small-percentage potential, when/if it
> does occur can be an absolute nightmare with all kinds of weird behavior.
> Rarely will you solve it from the context of a single server. There are
> lots of ways to cheat, but I believe they all have to be based on some
> small part that is guaranteed to be unique (like the IEEE id's).

That's the ideal world, sure :)

But the reality is, just like with ethernet MAC addresses, you don't 
always have one when you "supposed to" have one.

There are obvious limitations and problems arising from a generated WWN 
-- particularly for an HBA, where serial numbers and other unique 
identifiers are scarce.  But that doesn't wish the missing-WWN problem 
away.  Decades of networking experience have taught us a few things :)

As an aside, we also need a way to override the HBA's WWN, just like we 
do with ethernet MAC address.

	Jeff


