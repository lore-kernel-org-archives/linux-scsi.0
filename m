From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] driver model for scsi upper drivers, take 2
Date: Thu, 29 May 2003 12:23:26 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.52.0305291217110.2142@kai.makisara.local>
References: <20030527073218.GA11467@lst.de> <20030527094310.GA12853@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:62280 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S262017AbTE2JJ7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 05:09:59 -0400
In-Reply-To: <20030527094310.GA12853@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Tue, 27 May 2003, Christoph Hellwig wrote:

> On Tue, May 27, 2003 at 09:32:18AM +0200, Christoph Hellwig wrote:
> >  - removed the tape sysfs pseudodevice crap that caused hangs
> >  - switched sg to a class_interface.  This means sg can be used
> >    on devices already claimed be an upper driver again.  This
> >    also means I had to remove the sg sysfs attributes temporarily
> >    because the old mechanism is gone, but I'll restore them
> >    differently in a followon patch.
>
> Yikes, this was the old patch again.  Here's the right one:
>
I have done some tests with a disk, a tape, and different combinations
(in kernel/module) of the sd, st, sg, aic7xxx, and sym53c8xx_2
drivers. Looks good: devices are found and seem to work, no oopses
when loading/unloading modules. sysfs contents look correct (except
for the missing sg entries you said will re-appear in future).

-- 
Kai
