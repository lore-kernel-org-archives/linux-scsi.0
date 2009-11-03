From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] sd: WRITE SAME(16) / UNMAP support
Date: Tue, 3 Nov 2009 10:12:51 -0500
Message-ID: <20091103151251.GB19068@infradead.org>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com> <1256873409-12668-3-git-send-email-martin.petersen@oracle.com> <20091030051120.GE17714@infradead.org> <yq1639t9hnr.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711AbZKCPMs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 10:12:48 -0500
Content-Disposition: inline
In-Reply-To: <yq1639t9hnr.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

On Mon, Nov 02, 2009 at 08:32:08AM -0500, Martin K. Petersen wrote:
> >>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
> 
> Christoph> If we want to expose this we'd better do it at the block
> Christoph> layer
> 
> I agree.  I've already had several requests for "is this blkdev thinly
> provisioned?"...

Btw, I wonder if we should make a distinction between truely thing
provisioned and just discard capable devices like SSDs or other FTLs.

