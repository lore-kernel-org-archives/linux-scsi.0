From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH 2/3] scsi_forget_host - scsi_debug usage
Date: Mon, 14 Jun 2004 15:36:48 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040614133647.GJ1970@suse.de>
References: <20040612041930.GA21105@us.ibm.com> <20040612042106.GB21105@us.ibm.com> <20040612042232.GC21105@us.ibm.com> <20040614080632.GA7114@infradead.org> <20040614130619.GH1970@suse.de> <20040614132300.GA18926@infradead.org> <20040614132609.GI1970@suse.de> <20040614133045.GA19105@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:38288 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S263003AbUFNNgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jun 2004 09:36:50 -0400
Content-Disposition: inline
In-Reply-To: <20040614133045.GA19105@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Mon, Jun 14 2004, Christoph Hellwig wrote:
> On Mon, Jun 14, 2004 at 03:26:09PM +0200, Jens Axboe wrote:
> > > case we need to do it in shutdown aswell.
> > 
> > But the device is already SDEV_DEL there, so it can't be done without
> > fixing that. What makes the rootfs case special, btw?
> 
> The root device won't ever be closed, so you don't get the final sd_release
> call.

Ah yes, of course. If you want that to work, then there's no way around
juggling the device shutdown stuff around. Or flush cache on 2nd to last
release too :-)

-- 
Jens Axboe

