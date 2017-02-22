From: Christoph Hellwig <hch@lst.de>
Subject: Re: sense handling improvements
Date: Wed, 22 Feb 2017 08:19:15 +0100
Message-ID: <20170222071915.GA18084@lst.de>
References: <20170214191600.17480-1-hch@lst.de> <yq18tp6by2n.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:41411 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751192AbdBVHTS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Feb 2017 02:19:18 -0500
Content-Disposition: inline
In-Reply-To: <yq18tp6by2n.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernek.dk, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Feb 15, 2017 at 10:42:56PM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:
> 
> Christoph> this series is on top of the scsi_request changes in Jens'
> Christoph> tree and further improves the handling of the sense buffer.
> 
> Very nice cleanup!
> 
> Christoph> The first patch prevents any possibily of reusing stale sense
> Christoph> codes in sense headers, and is a bug fix that we should
> Christoph> probably get into the block tree ASAP.
> 
> Christoph> The rest cleans up handling of the parsed sense data and
> Christoph> could go in either through the block tree, or a SCSI branch
> Christoph> on top of the block tree.
> 
> I can bring them in after Linus' initial block pull.

Both the block and SCSI trees are now merged by Linus, and Jens didn't
pick up patch one from this series yet - maybe it's best to send the
whole series through the SCSI tree in this case.
