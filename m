From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-usb-devel] Re: USB storage problems on OHCI..
Date: Mon, 22 Sep 2003 10:19:54 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F6F2F3A.9020209@pacbell.net>
References: <Pine.LNX.4.44.0309221845480.12019-100000@notebook.home.mdiehl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta4.rcsntx.swbell.net ([151.164.30.28]:48540 "EHLO
	mta4.rcsntx.swbell.net") by vger.kernel.org with ESMTP
	id S263247AbTIVROz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Sep 2003 13:14:55 -0400
In-Reply-To: <Pine.LNX.4.44.0309221845480.12019-100000@notebook.home.mdiehl.de>
List-Id: linux-scsi@vger.kernel.org
To: Martin Diehl <lists@mdiehl.de>
Cc: Linus Torvalds <torvalds@osdl.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

Martin Diehl wrote:

> Unfortunately I don't see an easy way to check the sourced packed size on 
> the wire - except using a bus analyzer of course.

Right.  There are not-easy ways to do this, involving tricked out
host controller drivers usable only to debug things like this, but
I wouldn't want to go there myself!  :)

- Dave


