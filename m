From: Luben Tuikov <luben@splentec.com>
Subject: sector size, scsi_malloc(), sglist and queuecommand()?
Date: Fri, 14 Jun 2002 15:24:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D0A42E1.D0EC574B@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g5EJPnu06375
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2002 15:25:49 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

scsi_malloc() allocates with granularity of 512 bytes.

What happens when the device sector size is larger than 512?
i.e.
What is the size of a single scatterlist->length before it
is passed to queuecommand()?
I suppose a mutiple of the device sector size, which in turn
should be a mutiple of 512...

What happens when the request size is _not_ a multiple of 512.

Thanks,
-- 
Luben
