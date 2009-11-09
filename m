From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Thin provisioning update
Date: Mon, 9 Nov 2009 14:34:09 -0500
Message-ID: <20091109193409.GA26596@infradead.org>
References: <1257308740-4729-1-git-send-email-martin.petersen@oracle.com> <20091109142051.GC4855@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52788 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbZKITeI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2009 14:34:08 -0500
Content-Disposition: inline
In-Reply-To: <20091109142051.GC4855@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: hch@infradead.org, axboe@kernel.dk, matthew@wil.cx, linux-scsi@vger.kernel.org

So actually I'll take my previous comment back.  I think these patches
are good enough to put them in now to have something we can build on.
We might revise it later to move the adjustments of the trim ranges into
sd, but let's make sure we have something in for the merge window.

These patches work fine with my qemu and scsi_debug testing, and later
this week when I'm home I'll also try it with the OCZ SSD.

