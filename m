From: Dmitri Katchalov <dmitrik@users.sourceforge.net>
Subject: Re: [usb-storage] mode sense blacklist how
Date: Fri, 14 Nov 2003 14:11:08 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068779468.3fb447ccc6e60@webmail.netregistry.net>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>  <1068767049.2851.166.camel@patrh9>  <1068768796.3fb41e1c8d075@webmail.netregistry.net>  <1068775834.2851.321.camel@patrh9>  <20031113181945.I30194@one-eyed-alien.net> <1068777510.2851.359.camel@patrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from webmail.netregistry.net ([203.202.16.21]:57184 "EHLO
	webmail.netregistry.net") by vger.kernel.org with ESMTP
	id S264504AbTKNDLY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 22:11:24 -0500
In-Reply-To: <1068777510.2851.359.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: "mdharm-scsi@one-eyed-alien.net" <mdharm-scsi@one-eyed-alien.net>, "usb-storage@one-eyed-alien.net" <usb-storage@one-eyed-alien.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>, "patmans@us.ibm.com" <patmans@us.ibm.com>, "james.bottomley@steeleye.com" <james.bottomley@steeleye.com>, "ronald@kuetemeier.com" <ronald@kuetemeier.com>, "idan@idanso.dyndns.org" <idan@idanso.dyndns.org>

Quoting Pat LaVarre <p.lavarre@ieee.org>:

> To accomodate this device are we asking Dmitri K to give one last shot
> to telling us if kernel crash, boot fs crash, or other is the result of
> each of the twelve:
> 
> > > -i xC0 -y "1A 00:1C:00 C0 00" // Mode Sense (6)
> > > -i xC0 -y "1A 00:3F:00 C0 00" // Mode Sense (6)
> > > -i x0C -y "1A 00:00:00 0C 00" // Mode Sense (6)
> > > -i x0C -y "1A 00:3F:00 0C 00" // Mode Sense (6)
> > ...
> > -p -i xC0 -y "5A 00 1C:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
> > -p -i xC0 -y "5A 00 3F:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
> > -p -i x0C -y "5A 00 00:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)
> > -p -i x0C -y "5A 00 3F:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)
> > ...
> > -p -i xC4 -y "5A 00 1C:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
> > -p -i xC4 -y "5A 00 3F:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
> > -p -i x10 -y "5A 00 00:00:00:00 00 00:10 00 00:00" // Mode Sense (10)
> > -p -i x10 -y "5A 00 3F:00:00:00 00 00:10 00 00:00" // Mode Sense (10)
> 
> ?

I'll be away for the next 4 days. I'll try to test it now, 
if not I'll report when I come back. What exactly do you want me to do?

Regards,
Dmitri


