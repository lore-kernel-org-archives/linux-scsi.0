From: "Michael W. Shaffer" <mwshaffer@yahoo.com>
Subject: Re: [patch] Have qla2xxx driver bind fcports.
Date: Mon, 19 Jan 2004 13:40:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040119214030.78010.qmail@web10408.mail.yahoo.com>
References: <1074532278.1645.24.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web10408.mail.yahoo.com ([216.136.130.110]:21661 "HELO
	web10408.mail.yahoo.com") by vger.kernel.org with SMTP
	id S264329AbUASVkc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 16:40:32 -0500
In-Reply-To: <1074532278.1645.24.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Andrew Morton <akpm@osdl.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

> As far as the resync goes, I'd like to wait a while just to
> see if any more bugs turn up in the ioctl/failover separation
> piece ... it will be easier to debug if we have fewer changes,
> so how does early 2.6.2 sound for this (depending, of course,
> on when that actually is)?

Thanks to everyone for figuring this out so quickly. Should I
assume that this fix will be merged into 2.6.1-mm5 or so, and
eventually into 2.6.2? I'll probably continue to do some beta
testing on this system with the patches I have now, but I
would most likely wait until the LUN fix is into the -mm tree
before trying to move into production with it.


__________________________________
Do you Yahoo!?
Yahoo! Hotjobs: Enter the "Signing Bonus" Sweepstakes
http://hotjobs.sweepstakes.yahoo.com/signingbonus
