From: James Bottomley <jejb@steeleye.com>
Subject: Re: [PATCH] gdth: cleanup compat clutter
Date: Mon, 03 Jan 2005 10:29:06 -0600
Message-ID: <1104769747.5506.17.camel@mulgrave>
References: <20050103155057.GA24467@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:62122 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261492AbVACQ32 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jan 2005 11:29:28 -0500
In-Reply-To: <20050103155057.GA24467@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: achim_leubner@adaptec.com, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-01-03 at 16:50 +0100, Christoph Hellwig wrote:
>  - removes support for 2.2.x and 2.4.x without the full dma API
>    (<= 2.4.13 or 2.4.9rh)
>  - makes sure we don't acquire or release unessecary locks around
>    ->scsi_done - it's a small BH/softirq that doesn't care about
>    the callers lock state
>  - cleans up the 2.4 vs 2.6 compat code a little

When you said 'gdth' I noticed we hadn't heard from Achim for a while,
so I went back through the lists and pulled in some other gdth fixes
(from Jens: the buggy highmem problem and the stack reduction one from
Randy).  Of course, now, yours doesn't apply:

Patching file drivers/scsi/gdth.c
10 out of 131 hunks FAILED -- saving rejects to file
drivers/scsi/gdth.c.rej
Patching file drivers/scsi/gdth_proc.c
7 out of 26 hunks FAILED -- saving rejects to file
drivers/scsi/gdth_proc.c.rej

Could you re-roll against scsi-misc-2.6?  

Thanks,

James


