From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 04 Dec 2003 15:24:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070576669.2269.108.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
	 <1070573894.2269.47.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:17809 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263646AbTLDWpA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 17:45:00 -0500
In-Reply-To: <1070573894.2269.47.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> Does anybody know what ... mode page x1c do?  Although 
> nominally vendor-specific, they must be reasonably standardized if Windows 
> can get away with using them on a generic device.

I fetch my SPC guess from the web as follows.  As ever we cannot know if
MMC contradicts unless we check nearby.  To sort these clicks from most
to least applicable I logged them in reverse chronological order.

1Ch = Informational Exceptions Control

page 297 of 467 ...
7.4.5 Mode page and subpage formats and page codes ...
page 299 of 467 ...
Table 222 -- Mode page codes

SCSI Primary Commands - 3 (SPC-3)
http://www.t10.org/ftp/t10/drafts/spc3/spc3r15.pdf

SPC-3 SCSI Primary Commands - 3 ...
http://www.t10.org/drafts.htm#spc3

ANSI T10
http://www.t10.org/scsi-3.htm

Fun: Ramshackle World
http://members.aol.com/ppaatt/essay/why/

Pat LaVarre
http://members.aol.com/ppaatt/

http://www.google.com/search?q=Pat+LaVarre


