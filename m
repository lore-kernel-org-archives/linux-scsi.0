From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] Re: [PATCH 2.6.14] usb-storage: sat passthru
 sense size compatibility
Date: Fri, 9 Dec 2005 11:16:23 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0512091111220.6477-100000@iolanthe.rowland.org>
References: <20051209011749.GA29674@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60298 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932267AbVLIQQZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Dec 2005 11:16:25 -0500
In-Reply-To: <20051209011749.GA29674@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Timothy Thelin <timothy.thelin@wdc.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Dec 2005, Matthew Dharm wrote:

> Ugh.  Is there no way to convince the SCSI people to add an autosense
> request size field to the SRB?

This question belongs on the linux-scsi list (CC'ed).

Unless I'm mistaken, this feature would require a modification to the
block layer's struct request, since that is how all I/O requests are sent
to the SCSI core.  Perhaps Jens Axboe would be open to such modifications 
and perhaps not -- struct request is already pretty big.

> History has told us that doing much of anything based on cmnd[0] is a
> good way to get bitten very badly...

Agreed.

Alan Stern

