From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 14:30:45 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614133045.GA19105@infradead.org>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com> <20040614080632.GA7114@infradead.org> <20040614130619.GH1970@suse.de> <20040614132300.GA18926@infradead.org> <20040614132609.GI1970@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [213.146.154.40] ([213.146.154.40]:37847 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262963AbUFNNaq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 09:30:46 -0400
Content-Disposition: inline
In-Reply-To: <20040614132609.GI1970@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 14, 2004 at 03:26:09PM +0200, Jens Axboe wrote:
> > case we need to do it in shutdown aswell.
> 
> But the device is already SDEV_DEL there, so it can't be done without
> fixing that. What makes the rootfs case special, btw?

The root device won't ever be closed, so you don't get the final sd_release
call.

