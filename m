From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] block: Expose discard granularity
Date: Tue, 3 Nov 2009 10:12:11 -0500
Message-ID: <20091103151211.GA19068@infradead.org>
References: <1256873409-12668-1-git-send-email-martin.petersen@oracle.com> <1256873409-12668-2-git-send-email-martin.petersen@oracle.com> <20091030050719.GD17714@infradead.org> <yq1aaz59hpf.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45525 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbZKCPMN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 10:12:13 -0500
Content-Disposition: inline
In-Reply-To: <yq1aaz59hpf.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

On Mon, Nov 02, 2009 at 08:31:08AM -0500, Martin K. Petersen wrote:
> They all follow the block layer calling conventions.  They are also
> there to prevent the disaster that was the topology merge which exposed
> code all over the kernel that was poking directly at fields in struct
> request.

It's pretty nasy historic conventions we don't follow anywhere else.
If Jens insist on keeping the obsfucation we of course have to, but
recently even the block layer moved away from all that wrapping.

