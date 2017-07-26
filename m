From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: CPU lock-ups with 4.12.0+ kernels related to usb_storage
Date: Wed, 26 Jul 2017 11:50:46 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1707261150090.1965-100000@iolanthe.rowland.org>
References: <20170726154716.GA5722@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:49124 "HELO
        iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1750883AbdGZPur (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2017 11:50:47 -0400
In-Reply-To: <20170726154716.GA5722@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, SCSI development list <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>

On Wed, 26 Jul 2017, Christoph Hellwig wrote:

> On Thu, Jul 13, 2017 at 01:00:29PM -0400, Alan Stern wrote:
> > All right.  In the meantime, changing usb-storage won't hurt.
> > Arthur, can you test the patch below?
> 
> Do you plan to send this fix to Greg for 4.13-rc?

I just submitted it.

Alan Stern
