From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: RE: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 8 Apr 2003 06:29:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030408132949.36191.qmail@web21103.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21103.mail.yahoo.com ([216.136.227.105]:53510 "HELO
	web21103.mail.yahoo.com") by vger.kernel.org with SMTP
	id S261369AbTDHNSM (for <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2003 09:18:12 -0400
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com, James.Bottomley@steeleye.com
Cc: p.lavarre@ieee.org, mdharm-scsi@one-eyed-alien.net, torvalds@transmeta.com, linux-usb-devel@lists.sourceforge.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

> From: Patrick Mansfield [mailto:patmans@us.ibm.com]
> Sent: Mon 4/7/2003 4:33 PM ...
>
> Besides the current b/w listed items (except for
> the BLIST_INQUIRY_36/58 flags), we have:
>
> ... too long an INQUIRY request,
> ... report back wrong INQUIRY length
> ... don't like EVPD INQUIRY

And more.  Talk like Windows means say -x "12 0 0 0 24
0" -i x24 // op x12 Inquiry for 36, nothing else, at
least until broken 64-bit motherboards force us to x20
or x28.

> Why can't usb storage conditionally modify the
> INQUIRY to request no more than 36 bytes
> (allocation length), and modify any results to be
> <= 36 (additional length)?

sd.c isn't the only client of usb storage.

In particular, we need to hold on to some way of
letting sg pass thru op x12 Inquiry arbitrary enough
to copy In the vendor-specific data out past 36 bytes.
 Or to copy In the Ans-specified data out there that
lets an SFF/ ANSI MMC compliant device report an
attempt to comply simultaneously with the somewhat
contradictory ANSI SPC.

No?

Pat LaVarre
p.lavarre@ieee.org

P.S. Please ignore the Yahoo spam that follows, if any.

__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - File online, calculators, forms, and more
http://tax.yahoo.com
