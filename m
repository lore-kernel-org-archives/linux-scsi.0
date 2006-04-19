From: Andrew Morton <akpm@osdl.org>
Subject: areca RAID driver
Date: Wed, 19 Apr 2006 15:53:00 -0700
Message-ID: <20060419155300.321c352e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:35018 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751309AbWDSWup (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 18:50:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@suse.de>
Cc: erich <erich@areca.com.tw>, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org


Gents, Erich thinks that the Areca driver is pretty much ready to go.

We still have the weird read-past-EOF problem if MAX_XFER_SECTORS=4096, but
this version of the driver has it set to 512, which makes the problem go
away.  I've suggested that we can set that problem aside for now.

I've put a copy of the latest diff at
http://www.zip.com.au/~akpm/linux/patches/stuff/areca-raid-linux-scsi-driver.patch.
 Could you please take a look sometime, decide how we should proceed?

Thanks.

