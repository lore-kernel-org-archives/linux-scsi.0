From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Thin provisioning fixes
Date: Thu, 26 Nov 2009 12:01:57 +0100
Message-ID: <20091126110157.GV8742@kernel.dk>
References: <1258771524-26673-1-git-send-email-martin.petersen@oracle.com> <20091126105947.GA28120@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48905 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZKZLBw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2009 06:01:52 -0500
Content-Disposition: inline
In-Reply-To: <20091126105947.GA28120@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, james.bottomley@hansenpartnership.com, willy@wil.cx, jgarzik@pobox.com, sandeen@redhat.com, rwheeler@redhat.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Nov 26 2009, Christoph Hellwig wrote:
> What's the current state of this?
> 
> patch 4 is if I see this correctly withdrawn.  patch 1 could go into the
> block tree as is, and patch 3 into the libata tree, and patch 2 would
> replace the older one in the scsi post merge tree.
> 
> Jens, Jeff, James?

I was waiting for the discussion to settle and a repost. Let me know if
I should just pick up the current #1.

-- 
Jens Axboe

