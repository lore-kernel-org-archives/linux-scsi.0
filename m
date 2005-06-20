From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH, scsi-block-2.6] remove bio_map_user
Date: Mon, 20 Jun 2005 12:42:29 +0200
Message-ID: <20050620104229.GB4246@lst.de>
References: <20050619092946.GA16872@lst.de> <20050620103709.GA15021@suse.de> <20050620103656.GA4164@lst.de> <20050620104114.GD15021@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:12224 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261165AbVFTKmc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 06:42:32 -0400
Content-Disposition: inline
In-Reply-To: <20050620104114.GD15021@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Jun 20, 2005 at 12:41:14PM +0200, Jens Axboe wrote:
> > That would be?
> 
> Stacking drivers or file systems.

Doesn't make sense, a stacking driver must not deal with locking down
user memory at all, and for filesystem there's better helpers in
fs/direct-io.c

> > > While I do agree with the change, I know of external users of
> > > bio_map_user().
> > 
> > Who's that?
> 
> ocfs2, iirc.

ocfs2 doesn't use bio_map_user

