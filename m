From: David Brownell <david-b@pacbell.net>
Subject: Re: Usb storage mounting was broken
Date: Wed, 22 Oct 2003 11:44:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F96D00E.1080500@pacbell.net>
References: <1066775616.3458.8.camel@m70.net81-64-235.noos.fr>	 <20031021175556.A8670@beaverton.ibm.com>	 <1066808944.3699.9.camel@ulysse.olympe.o2t> <3F969E04.6060801@pacbell.net>	 <1066837537.6960.3.camel@ulysse.olympe.o2t> <3F96AE64.5020305@pacbell.net> <1066845819.2806.11.camel@m70.net81-64-235.noos.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtaw6.prodigy.net ([64.164.98.56]:16377 "EHLO mtaw6.prodigy.net")
	by vger.kernel.org with ESMTP id S263488AbTJVSjq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Oct 2003 14:39:46 -0400
In-Reply-To: <1066845819.2806.11.camel@m70.net81-64-235.noos.fr>
List-Id: linux-scsi@vger.kernel.org
To: Nicolas Mailhot <Nicolas.Mailhot@laPoste.net>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org


> The only weird thing is some messages made it to /var/log/messages,
> /var/log/kernel and show up with dmesg, but didn't end up in
> /var/log/dmesg (which is what I used as attachement before, but the
> other messages were extracted from /var/log/kernel and put in the bug
> too). I suppose RedHat stops writing in /var/log/dmesg after the end of
> the boot.

As a rule, "dmesg output" means "output of dmesg command" ... :)
Boot messages (/var/log/dmesg) aren't a substitute.

OK, at this point what's needed is the more customary usb debug
information.  Contents of /proc/bus/usb/devices for starters.
And since this resembles an enumeration failure, it'd be good
to have the Alt-Sysrq-t output for "khubd".

And does this happen if you try this with, say, OHCI not EHCI?

- Dave


