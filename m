From: Meelis Roos <mroos@linux.ee>
Subject: RE: [PATCH] hpsa: add support for legacy boards
Date: Tue, 11 Jul 2017 18:58:36 +0300 (EEST)
Message-ID: <alpine.LRH.2.20.1707111853330.9598@math.ut.ee>
References: <1499755744-79217-1-git-send-email-hare@suse.de> <alpine.LRH.2.20.1707111547060.31569@math.ut.ee> <4993A297653ECB4581FA5C3C31323D19533CE9D1@avsrvexchmbx2.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:44513 "EHLO smtp2.it.da.ut.ee"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755625AbdGKP6k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Jul 2017 11:58:40 -0400
In-Reply-To: <4993A297653ECB4581FA5C3C31323D19533CE9D1@avsrvexchmbx2.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Jens Axboe <axboe@kernel.dk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

> The 5i controller is probably too old for the hpsa driver to support. 
> The hpsa driver is looking for information to determine if the drive is online/offline and
> this information is not available.
> 
> What was the original issue you were having with the cciss driver?

Christoph Hellwig updated block layer with "block: Make most 
scsi_req_init() calls implicit" and at first try, cciss was left without 
the needed initialization. This caused OOPS in udev probing but the 
system worked. The issue was fixed by Christoph quickly.

But he suggested it might be worth trying hpsa driver instead of cciss, 
with a longer term goal to to move users of cciss over to hpsa if 
possible. Now that I have tested it, it seems not all older cards are 
supported in hpsa - it's more than ID-s and interrupt masks.

-- 
Meelis Roos (mroos@linux.ee)
