From: <random1@o-o.yi.org>
Subject: Re: Sym53C8xx Driver Hardening
Date: 23 Jul 2002 11:11:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <uptxev5rg.fsf@o-o.yi.org>
References: <200207231357.PAA02632@cave.bitwizard.nl> <1027437862.31787.136.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from list by main.gmane.org with local (Exim 3.33 #1 (Debian))
	id 17X1Jf-0008Ki-00
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2002 17:11:11 +0200
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> The high reliability people take a different view. I actually agree with
> them. It isnt about 'oops didnt happen' it is about controlling the
> failure case

"graceful degradation" -- it's been being taught in CS curricula for
*at least* twenty years.  I'm disturbed by all the places that people
have chosen, when faced with the unexpected, to just panic, rather
than find a way to get back to some semblence of a running system.

I don't want some goofy UPS hanging off a USB bus, for instance, to
take down a critical storage server.



