From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] switch scsi upper driver probing to the driver model
Date: Sat, 17 May 2003 10:32:50 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030517083250.GV812@suse.de>
References: <20030516182039.A7369@lst.de> <3EC5B3B8.9020308@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:41378 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S261309AbTEQIUF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 May 2003 04:20:05 -0400
Content-Disposition: inline
In-Reply-To: <3EC5B3B8.9020308@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sat, May 17 2003, Douglas Gilbert wrote:
>   - the SG_IO ioctl in the block level
>      - limits maximum transfer size to 65536 bytes

Correct, we can remove that though.

>      - does not support mmap-ed IO [and would need
>        something like a reserved buffer concept to do it]

Why should it?

>      - does not support direct IO

False, it uses direct IO all the time if the alignment is correct.

>      - needs work (debuggings)

Know of any bugs?

-- 
Jens Axboe

