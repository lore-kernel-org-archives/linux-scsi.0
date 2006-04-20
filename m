From: Jens Axboe <axboe@suse.de>
Subject: Re: areca RAID driver
Date: Thu, 20 Apr 2006 08:44:52 +0200
Message-ID: <20060420064452.GP614@suse.de>
References: <20060419155300.321c352e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:35412 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S1751192AbWDTGoW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Apr 2006 02:44:22 -0400
Content-Disposition: inline
In-Reply-To: <20060419155300.321c352e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, erich <erich@areca.com.tw>, billion.wu@areca.com.tw, linux-scsi@vger.kernel.org

On Wed, Apr 19 2006, Andrew Morton wrote:
> 
> Gents, Erich thinks that the Areca driver is pretty much ready to go.
> 
> We still have the weird read-past-EOF problem if MAX_XFER_SECTORS=4096, but
> this version of the driver has it set to 512, which makes the problem go
> away.  I've suggested that we can set that problem aside for now.

The hardware clearly just cannot handle that large a xfer size, so it
should just be left at 512 until that problem is fully understood at
Areca's end.

-- 
Jens Axboe

