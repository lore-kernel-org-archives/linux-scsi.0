From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] mode sense blacklist how
Date: 14 Nov 2003 10:27:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068830856.5539.47.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <20031113184430.A6579@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:31619 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264626AbTKNR2L
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 12:28:11 -0500
In-Reply-To: <20031113184430.A6579@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, dmitrik@users.sourceforge.net, stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

> > Ouch, one last thing: tell me again what device/interface descriptors
> > our usb-storage by default tries to support?
> > 
> > Is that bInterfaceClass ...SubClass ...Protocol = x 08 XX (00|01|50)? 
> > Or just x 08 (00..06|FF) (00|01|50)?  (Clearly it's not just the
> > formally defined x 08 (00..06) (00|01|50).)
> 
> We support x 08 (00..06) (00|01|50).) plus whatever is listed in the
> unusual_devs.h file.

Ouch.  I guessed soooo wrong.  I see already we connect automagically
only with devices that claim compliance to a published standard.  Good
to hear, thank you.  Starting again now:

I hear you saying we're talking SCSI to our failing Sony stick only
because we patched unusual_devs.h?

When we patch unusual_devs.h to say to talk to this Sony stick, how
about we simultaneously patch in a flag to say don't talk mode sense to
it?

As you can see, by now I see only the principle that we can see sd
doesn't yet quite Talk Like Windows.  I've lost track of why
specifically now we believe sd has an issue we should fix.  

Help?

Pat LaVarre


