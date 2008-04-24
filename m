From: Miquel van Smoorenburg <miquels@cistron.nl>
Subject: Re: [PATCH 1/2] dpt_i2o: 64 bit support (take 3)
Date: Thu, 24 Apr 2008 22:24:48 +0200
Message-ID: <1209068688.6092.3.camel@localhost.localdomain>
References: <20080424150717.GA21438@xs4all.net>
	 <1209051593.3121.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3789 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760464AbYDXUWu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Apr 2008 16:22:50 -0400
In-Reply-To: <1209051593.3121.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Linux-Scsi <linux-scsi@vger.kernel.org>


On Thu, 2008-04-24 at 10:39 -0500, James Bottomley wrote:
> Just gave it a cursory glance, and it looks OK, except for things like
> this:
> 
> On Thu, 2008-04-24 at 17:07 +0200, Miquel van Smoorenburg wrote:
> > +#elif defined(__linux__)
> 
> Could you get rid it, please?  For inclusion in the kernel, you can take
> it as read that we're operating in a Linux environment, so the symbol
> will always be defined (so you can just strip out the code that depends
> on this symbol not being defined).

Ofcourse. I did it this way because I wanted to follow the style of the
existing code as much as possible, and I did not want to change the
existing code too much. There's more stuff in there that needs a
cleanup, but that needs to be done seperately.

I'll fix the defined(__linux__) stuff, and I'll rip out the unused
reboot_notifier stuff as well.

Mike.

