From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: default to scsi-mq
Date: Mon, 26 Jun 2017 11:48:11 +0200
Message-ID: <20170626094811.GC13981@lst.de>
References: <20170616082755.22832-1-hch@lst.de> <1498143933.6002.18.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:37442 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdFZJsR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 05:48:17 -0400
Content-Disposition: inline
In-Reply-To: <1498143933.6002.18.camel@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Wilck <mwilck@suse.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, Jun 22, 2017 at 05:05:33PM +0200, Martin Wilck wrote:
> Hello Christoph,
> 
> On Fri, 2017-06-16 at 10:27 +0200, Christoph Hellwig wrote:
> > Remove the SCSI_MQ_DEFAULT config option and default to the blk-mq
> > I/O
> > path now that we had plenty of testing, and have I/O schedulers for
> > blk-mq.  The module option to disable the blk-mq path is kept around
> > for now.
> 
> Could you explain why you remove the option entirely rather than just
> changing the default? Some distributions may wish to keep the ability
> to choose the compiled-in default.

Because the legacy code will go away, and I want people to prepare for
that.
