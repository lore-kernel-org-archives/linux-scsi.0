From: Jens Axboe <axboe@suse.de>
Subject: Re: [patch 2/4] ibmvscsi.c: limit size of I/O requests
Date: Tue, 30 Nov 2004 08:54:58 +0100
Message-ID: <20041130075457.GD10450@suse.de>
References: <20041129203107.GB31011@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:32972 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S262003AbUK3Hz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 02:55:27 -0500
Content-Disposition: inline
In-Reply-To: <20041129203107.GB31011@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: sleddog@us.ibm.com

On Mon, Nov 29 2004, Dave C Boutcher wrote:
> Description: Limit the size of I/O requests sent by the 
> ibmvscsi adapter.  With better I/O scheduling (and thus larger
> requests) we were breaking some servers.

Nack, why can't you use /dev/block/xxx/queue/max_sectors_kb to control
this?

-- 
Jens Axboe

