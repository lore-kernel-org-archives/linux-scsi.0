From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] /proc/scsi/map
Date: Thu, 20 Jun 2002 14:52:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206201852.g5KIqoJ06342@localhost.localdomain>
References: <torvalds@transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id LAA18982
	for <linux-scsi@vger.kernel.org>; Thu, 20 Jun 2002 11:52:56 -0700
In-Reply-To: Message from Linus Torvalds <torvalds@transmeta.com>
   of "Thu, 20 Jun 2002 11:36:25 PDT." <Pine.LNX.4.44.0206201133180.8225-100000@home.transmeta.com>
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Andries Brouwer <aebr@win.tue.nl>, Martin Schwenke <martin@meltin.net>, Kurt Garloff <garloff@suse.de>, Linux kernel list <linux-kernel@vger.kernel.org>, Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mochel <mochel@osdl.org>

torvalds@transmeta.com said:
> SCSI people, how does that patch look to you? Apparently it does
> everything the scsimap thing does, in a way that is certainly
> acceptable to me. 

It looks OK to me.  It doesn't quite do everything you want in terms of doing 
your bus1/id2/lun0 piece, but it's a good start.

We should probably have some more discussion about the layout of the device 
tree, particularly if it's going to be consistent with other devices like ide 
discs and cds.

I'd like to see the "name" field become mutable from user level somehow just 
so we can fix the enterprise name on broken devices without having to have a 
huge kernel exception table, but that's my only current concern.

James


