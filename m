From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 19:14:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209242314.g8ONEHU02783@localhost.localdomain>
References: <rmk@arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA22396
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2002 16:14:23 -0700
In-Reply-To: Message from Russell King <rmk@arm.linux.org.uk>
   of "Tue, 24 Sep 2002 23:39:42 BST." <20020924233941.A9952@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

rmk@arm.linux.org.uk said:
> Now, as I say, this is only _half_ of my fixes.  This fixes the SCSI
> door locking problem.  It doesn't fix the complete bus hangs when the
> new error handing kicks in, fails, and takes devices off line.  We'll
> deal with that can of worms when we've got this one out of the way.

This looks fine to me, except the bit where you free the command and request 
from inside the done function.  I can't find anywhere we might touch the 
request again after this, so I suppose it's safe for now.

send it off to Marcelo and I'll try to up-port to 2.5

James


