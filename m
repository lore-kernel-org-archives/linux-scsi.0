From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi-misc-2.5 remove scsi_device list_lock
Date: Fri, 25 Apr 2003 09:53:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030425095326.C8776@beaverton.ibm.com>
References: <20030424100229.A32098@beaverton.ibm.com> <20030425111212.A28577@infradead.org> <20030425104745.GK1012@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 216-99-218-173.dsl.aracnet.com ([216.99.218.173]:9969 "EHLO
	dyn9-47-17-132.beaverton.ibm.com") by vger.kernel.org with ESMTP
	id S263381AbTDYQpG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Apr 2003 12:45:06 -0400
Content-Disposition: inline
In-Reply-To: <20030425104745.GK1012@suse.de>; from axboe@suse.de on Fri, Apr 25, 2003 at 12:47:46PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Fri, Apr 25, 2003 at 12:47:46PM +0200, Jens Axboe wrote:

> Again... Besides, this alias _must_ only be used by the block layer.
> Every other driver should use the real one.

So we should never use queue_lock in the scsi code? 

I wasn't sure which way to go, previous code used queue_lock in scsi queue
related code (well almost everywhere) rather than host_lock.

-- Patrick Mansfield
