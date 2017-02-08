From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 07/18] lpfc: NVME Initiator: Base modifications Part E
Date: Wed, 8 Feb 2017 04:47:54 -0800
Message-ID: <20170208124754.GA23225@infradead.org>
References: <58990208.nZVFaqC7RkseErlq%jsmart2021@gmail.com>
 <5881e84b-c932-f812-7f41-a16152d12106@suse.de>
 <52f4f81e-2353-4da2-7ce9-a7cd7796e1f7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:53760 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754152AbdBHNeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2017 08:34:23 -0500
Content-Disposition: inline
In-Reply-To: <52f4f81e-2353-4da2-7ce9-a7cd7796e1f7@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>, linux-nvme@lists.infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org

On Tue, Feb 07, 2017 at 06:32:30PM -0800, James Smart wrote:
> I realize I cut these in a silly way.  In the v1 patches, I had a big patch
> that I then cut into 6 parts, by file.  In the v2 patches, I tried to keep
> the patches as is, and address the comments in the respective patch the
> comment came from. Which resulted in 3/8 with an old reference, but patch
> 8/8 being the one that reverted this reverence. Sorry..  I'll recut and
> repost.

This whole split doesn't make sense - either the patches are logically
split, in which case they can be posted separately, or they belong
together in which case they should be sent together.  But the size
of them suggest to me they probably need to be broken down to logically
separate patches.

And can you please switch to using git-send-email to send the patches
straight from a git branch?  There are lot of patch formatting issues
with the lpfc patches, and that should fix most of them instantly.
