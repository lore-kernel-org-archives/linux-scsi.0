From: Greg Stark <gsstark@mit.edu>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: 22 Feb 2005 12:06:09 -0500
Message-ID: <874qg4v81q.fsf@stark.xeocode.com>
References: <20050127120244.GO2751@suse.de> <87acpxurwf.fsf@stark.xeocode.com>
	<20050222071340.GC2835@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from gsstark.mtl.istop.com ([66.11.160.162]:14477 "EHLO
	stark.xeocode.com") by vger.kernel.org with ESMTP id S261187AbVBVRGT
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Feb 2005 12:06:19 -0500
In-Reply-To: <20050222071340.GC2835@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Greg Stark <gsstark@mit.edu>, Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org


Jens Axboe <axboe@suse.de> writes:

> fsync has been working all along, since the initial barrier support for
> ide. only ext3 and reiserfs support it.

Really? That's huge news. Since what kernel version(s) is that?

What about a non-journaled fs, or at least a meta-data-only-journaled fs?
Journaled FS's don't mix well with transaction based databases since they're
basically doing their own journaling anyways.

-- 
greg

