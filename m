From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] get rid of ->finish method for highlevel drivers
Date: Mon, 21 Oct 2002 18:58:36 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210212358.g9LNwaV05299@localhost.localdomain>
References: <hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id QAA19629
	for <linux-scsi@vger.kernel.org>; Mon, 21 Oct 2002 16:58:40 -0700
In-Reply-To: Message from Christoph Hellwig <hch@lst.de>
   of "Mon, 21 Oct 2002 21:34:41 +0200." <20021021213441.A2864@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

hch@lst.de said:
> the ->finish method is a relicat from the old day were we never had
> hotplugging and allowed the driver to do fixups after all busses had
> been scanned.  Nowdays only sd and sr actually implement it, and both
> only defer actions to there that should actually happen in ->attach.
> Change both drivers to move that code into ->attach, clenaup the
> Templates to use C99 initializers and get rid of the methods. 

OK, this one causes a hang on boot for me.  I'll look at debugging the cause 
some more tomorrow.

James


