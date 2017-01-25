From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] SCSI core: Fix WRITE SAME handling
Date: Wed, 25 Jan 2017 11:37:25 +0100
Message-ID: <20170125103725.GA18026@lst.de>
References: <5bedd463-8f55-4506-0593-fd0040c47a17@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:36727 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751672AbdAYKh2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Jan 2017 05:37:28 -0500
Content-Disposition: inline
In-Reply-To: <5bedd463-8f55-4506-0593-fd0040c47a17@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Hi Bart,

thanks for the report.

> Fixes: f80de881d8df ("sd: remove __data_len hack for WRITE SAME")

I think the better fix is to simply revert this commit.
