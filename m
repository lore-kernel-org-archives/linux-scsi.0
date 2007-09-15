From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [RFC PATCH] SCSI: split Kconfig menu into two
Date: Sat, 15 Sep 2007 11:44:59 -0400
Message-ID: <46EBFDFB.5040401@garzik.org>
References: <tkrat.913e8b183cdf7888@s5r6.in-berlin.de> <20070914190033.GA4003@uranus.ravnborg.org> <20070914190609.GN3563@stusta.de> <tkrat.552dbee831c88bbe@s5r6.in-berlin.de> <20070915114055.GP3563@stusta.de> <46EBCEF1.4030702@s5r6.in-berlin.de> <20070915125055.GQ3563@stusta.de> <46EBDC06.3030202@s5r6.in-berlin.de> <20070915135314.GS3563@stusta.de> <46EBE821.2080300@s5r6.in-berlin.de> <20070915144341.GT3563@stusta.de> <46EBF9DC.1000503@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:39736 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948AbXIOPpQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Sep 2007 11:45:16 -0400
In-Reply-To: <46EBF9DC.1000503@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Adrian Bunk <bunk@kernel.org>, Sam Ravnborg <sam@ravnborg.org>, James Bottomley <james.bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Andi Kleen <andi@firstfloor.org>, Folkert van Heusden <folkert@vanheusden.com>, linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Adrian Bunk wrote:
>> On Sat, Sep 15, 2007 at 04:11:45PM +0200, Stefan Richter wrote:
>>> Perfect is in the eye of the beholder.  You would consequently have to
>>> add such options into all menus which contain scsi low-level providers.
>> Kconfig is a user interface, so perfect is what is best for the
>> kconfig users.
> 
> Duplicate options with different names in different menus, but which all
> do the same, --- is this the best for users?

I recognize it's a rhetorical question :)  The answer is of course "no".

I hope the other participants of this thread register the severe 
disinclination of the maintainers to change this stuff, as this is a 
classic case of making a mountain out of a molehill[1].

For the -vast majority- of people configuring the kernel, this is not a 
problem.  Kernel people are -expected- to know what they're doing, 
especially when switching from one major subsystem to another.

Therefore, all this is IMO wasted effort and hot air.  There are far 
more important issues to deal with.

	Jeff


[1] http://www.bartleby.com/59/4/makeamountai.html
