From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Sat, 28 Aug 2004 11:14:28 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408281109550.30753-100000@netrider.rowland.org>
References: <20040828143124.GB2518@suse.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:19975 "HELO
	netrider.rowland.org") by vger.kernel.org with SMTP id S266888AbUH1PO3
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 Aug 2004 11:14:29 -0400
In-Reply-To: <20040828143124.GB2518@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Pat LaVarre <p.lavarre@ieee.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Sat, 28 Aug 2004, Jens Axboe wrote:

> > I wasn't sure whether there were any other limitations somewhere else in 
> > the block layer, so for now in usb-storage max_sectors is capped at 
> > SCSI_DEFAULT_MAX_SECTORS = 1024.  Allowing it to increase by almost a 
> > factor of 64 could remove a lot of latency.
> 
> How do you come to that conclusion? 1024 is probably a fine value,
> usually there's very little benefit to going higher than that (since
> huge requests on slower hardware increases latency quite a lot, and huge
> requests only provide little (if any) throughput increase on fast
> hardware).

Actually I have no basis for saying there will be any significant benefit 
from going higher than 1024.  Pat LaVarre is interested in trying higher 
values, that's all.

> That said, it still wants splitting into two before you should go
> higher.

I don't understand.  What needs to be split into two?  And why?

Alan Stern

