From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi/sata write barrier support
Date: Tue, 1 Mar 2005 09:47:42 +0100
Message-ID: <20050301084741.GD12295@suse.de>
References: <20050127120244.GO2751@suse.de> <87acpxurwf.fsf@stark.xeocode.com> <20050222071340.GC2835@suse.de> <874qg4v81q.fsf@stark.xeocode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from ns.virtualhost.dk ([195.184.98.160]:30672 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261804AbVCAIrv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2005 03:47:51 -0500
Content-Disposition: inline
In-Reply-To: <874qg4v81q.fsf@stark.xeocode.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Stark <gsstark@mit.edu>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Bartlomiej Zolnierkiewicz <B.Zolnierkiewicz@elka.pw.edu.pl>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On Tue, Feb 22 2005, Greg Stark wrote:
> 
> Jens Axboe <axboe@suse.de> writes:
> 
> > fsync has been working all along, since the initial barrier support for
> > ide. only ext3 and reiserfs support it.
> 
> Really? That's huge news. Since what kernel version(s) is that?

Since 2.6.9.

> What about a non-journaled fs, or at least a meta-data-only-journaled fs?
> Journaled FS's don't mix well with transaction based databases since they're
> basically doing their own journaling anyways.

Only works on ext3 and reiserfs currently.

-- 
Jens Axboe

