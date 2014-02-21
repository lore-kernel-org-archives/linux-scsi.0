From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/3] next round of blk-mq updates
Date: Fri, 21 Feb 2014 08:58:23 -0800
Message-ID: <20140221165823.GE30251@kernel.dk>
References: <20140220233235.443299098@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:62231 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932441AbaBUQ61 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Feb 2014 11:58:27 -0500
Received: by mail-pb0-f53.google.com with SMTP id ma3so1045998pbc.12
        for <linux-scsi@vger.kernel.org>; Fri, 21 Feb 2014 08:58:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20140220233235.443299098@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Feb 20 2014, Christoph Hellwig wrote:
> A couple more blkmq updates: a trivial cleanup, a consolidation of two very
> similar functions into one, and support for partial request completions,
> a feature needed by the work in progress scsi blk-mq support.

Thanks, applied all 3. The end_io is a bit fatter than it was before,
which is a shame. But on the plus side, it's consistent...

-- 
Jens Axboe

