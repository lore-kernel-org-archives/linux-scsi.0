From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: usb storage traces
Date: Thu, 4 Dec 2003 21:08:32 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031204210832.A1757@beaverton.ibm.com>
References: <20031204184428.GA17116@one-eyed-alien.net> <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.104]:45460 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S263857AbTLEFJH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Dec 2003 00:09:07 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0312041509380.994-100000@ida.rowland.org>; from stern@rowland.harvard.edu on Thu, Dec 04, 2003 at 03:59:58PM -0500
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Pat LaVarre <p.lavarre@ieee.org>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, Dec 04, 2003 at 03:59:58PM -0500, Alan Stern wrote:

> It was generic (transparent) scsi.
> 
> Perhaps I'll try implementing some of the other protocol codes in FSG,
> maybe also the "removeable media" flag.  This would also require
> implementing the PREVENT-ALLOW-MEDIUM-REMOVAL, READ-FORMAT-CAPACITIES, and
> START-STOP, possibly also REZERO-UNIT, SEEK, READ(12), and WRITE(12).

What is FSG?

-- Patrick Mansfield
