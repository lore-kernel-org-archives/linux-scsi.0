From: Greg Stark <gsstark@mit.edu>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: 21 Feb 2005 23:42:40 -0500
Message-ID: <87acpxurwf.fsf@stark.xeocode.com>
References: <20050127120244.GO2751@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from gsstark.mtl.istop.com ([66.11.160.162]:16775 "EHLO
	stark.xeocode.com") by vger.kernel.org with ESMTP id S262204AbVBVEmy
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Feb 2005 23:42:54 -0500
In-Reply-To: <20050127120244.GO2751@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org


Jens Axboe <axboe@suse.de> writes:

> For the longest time, only the old PATA drivers supported barrier writes
> with journalled file systems. 

What about for fsync(2)? One of the most frequent sources of data loss on the
postgres mailing list has to do with users with IDE drives where fsync returns
even though the data hasn't actually reached the disk. A power outage can
cause lost data or a corrupted database.

Is there any progress getting fsync to use this new infrastructure so it can
actually satisfy its contract?

-- 
greg

