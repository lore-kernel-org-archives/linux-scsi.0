From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 04 Dec 2003 15:28:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070576899.2269.115.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
	 <1070573894.2269.47.camel@patibmrh9>  <1070576669.2269.108.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:20370 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263653AbTLDWsx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2003 17:48:53 -0500
In-Reply-To: <1070576669.2269.108.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> MODE-SENSE	6: 1a 00 00 00 0c 00  In 12
> 	I don't know what Windows expects to find in page 0;
> 	but this fails

Last I checked, page 0 was vendor-specific.  I don't clearly remember if
the header before page 0 was standard.  If yes, then Win could be
legitly fetching header alone e.g. to check write-protect.

Pat LaVarre


