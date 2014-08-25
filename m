From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: RES: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 15:33:49 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408251526390.1385-100000@iolanthe.rowland.org>
References: <40601ab081d3451baf6267807659c80e@serv030.corp.eldorado.org.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:36625 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933223AbaHYTdu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 15:33:50 -0400
In-Reply-To: <40601ab081d3451baf6267807659c80e@serv030.corp.eldorado.org.br>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>
Cc: Oliver Neukum <oneukum@suse.de>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 25 Aug 2014, Alfredo Dal Ava Junior wrote:

> On Mon, 25 Aug 2014, Alan Stern wrote:
> > 
> > Don't forget that lots of disks go crazy if you try to read from a nonexistent
> > block, that is, one beyond the end of the disk.
> > IMO, this bug cannot be worked around in any reasonable manner.  The
> > device simply cannot handle disks larger than 2 TB.
> 
> 
> This device works well on Windows 7 if HDD is already partitioned.
> Sounds like Win7 gnores the READ_CAPACITY value on a partitioned HDD.
> It shows 4TB on disk manager, but will fall back to 1.8TB if I remove
> the partition.

That's right.  I don't know why Windows behaves that way.

> Could we do the same? Would be possible to signalize to upper layers
> that capacity is not accurate (or return zero) on this device, and
> tell GPT handlers to bypass it's partition_size vs disk size
> consistency check?

There is no way to do this, as far as I know.  But I'm not an expert in 
this area.  Maybe you can figure out a way to add this capability.

(But then what happens if the size stored in the partition table really
is larger than the disk's capacity?)

Alan Stern

