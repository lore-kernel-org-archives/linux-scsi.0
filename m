From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Kill SCSI_BH
Date: Sun, 16 Jun 2002 11:55:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200206161655.g5GGtA122913@localhost.localdomain>
References: <willy@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id JAA18469
	for <linux-scsi@vger.kernel.org>; Sun, 16 Jun 2002 09:55:15 -0700
In-Reply-To: Message from Matthew Wilcox <willy@debian.org>
   of "Sun, 16 Jun 2002 04:01:11 BST." <20020616040111.P9435@parcelfarce.linux.theplanet.co.uk>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: linux-scsi@vger.kernel.org

willy@debian.org said:
> Andrew Morton kindly tested this patch for me and reports it works
> fine. I'd expect the Enterprise people to be thrilled by this as it
> increases scalability a touch (eg, SCSI handling is now not serialised
> against the serial port). 

It works fine for me on an 8-way box with SCSI root discs.  Go ahead and send 
it to Linus as an obvious fix (given that the bottom half handlers are 
supposed to be deprecated).  I've also stuck it in a public bitkeeper 
repository at:

http://linux-scsi.bkbits.net/scsi-mid-layer-2.5

James



