From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock
Date: Fri, 25 Apr 2003 19:20:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425172041.GS1012@suse.de>
References: <20030424100229.A32098@beaverton.ibm.com> <20030425111212.A28577@infradead.org> <20030425104745.GK1012@suse.de> <20030425095326.C8776@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:24513 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263298AbTDYRId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 13:08:33 -0400
Content-Disposition: inline
In-Reply-To: <20030425095326.C8776@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25 2003, Patrick Mansfield wrote:
> On Fri, Apr 25, 2003 at 12:47:46PM +0200, Jens Axboe wrote:
> 
> > Again... Besides, this alias _must_ only be used by the block layer.
> > Every other driver should use the real one.
> 
> So we should never use queue_lock in the scsi code? 

Basically, no. The only place where it _might_ be appropriate, is the
entry points from the block layer where it is already held (for
clarity). That's basically scsi_request_fn only.

-- 
Jens Axboe

