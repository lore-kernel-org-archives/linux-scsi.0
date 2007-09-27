From: Michael Reed <mdr@sgi.com>
Subject: Re: generating a Linux WWN?
Date: Thu, 27 Sep 2007 09:29:38 -0500
Message-ID: <46FBBE52.1080507@sgi.com>
References: <46FB8024.8040807@garzik.org> <46FBB86B.8000206@emulex.com> <46FBBBEB.4020605@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59417 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757477AbXI0O3n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Sep 2007 10:29:43 -0400
In-Reply-To: <46FBBBEB.4020605@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: James.Smart@Emulex.Com, linux-scsi <linux-scsi@vger.kernel.org>



Jeff Garzik wrote:
> James Smart wrote:
>> Uh, although this may work very well for small constrained configs, as one
>> who debugs larger environments (and things always grow or get connected in
>> ways you don't expect), depending on a random number for uniqueness makes
>> me very unsettled. Debugging that small-percentage potential, when/if it
>> does occur can be an absolute nightmare with all kinds of weird behavior.
>> Rarely will you solve it from the context of a single server. There are
>> lots of ways to cheat, but I believe they all have to be based on some
>> small part that is guaranteed to be unique (like the IEEE id's).
> 
> That's the ideal world, sure  :) 
> 
> But the reality is, just like with ethernet MAC addresses, you don't always have one when you "supposed to" have one.
> 

I'm curious about the problem you're trying to solve.  Generally a missing WWN,
as having a unique WWN should be a product requirement, is an indicator of
a problem.  Shouldn't the proper solution be to have the card repaired?
Arbitrarily assigning a WWN could mask or introduce other problems, in particular
with regard to storage connectivity.

> There are obvious limitations and problems arising from a generated WWN -- particularly for an HBA, where serial numbers and other unique identifiers are scarce.  But that doesn't wish the missing-WWN problem away.  Decades of networking experience have taught us a few things  :) 
> 
> As an aside, we also need a way to override the HBA's WWN, just like we do with ethernet MAC address.

We do?  Perhaps if it's corrupt and you know the correct value.  But, in that case
shouldn't the card be replaced?  When would you need to override the default WWN?

Linux: it's not just for desktops anymore.  :)

Mike


> 
>     Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
