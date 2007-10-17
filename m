From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 10:45:28 +0200
Message-ID: <20071017084528.GI5043@kernel.dk>
References: <20071017140747Q.fujita.tomonori@lab.ntt.co.jp> <20071017072149.GC5041@kernel.dk> <20071017.013325.74747630.davem@davemloft.net> <20071017.014211.41637735.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:6675 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755533AbXJQIpz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 04:45:55 -0400
Content-Disposition: inline
In-Reply-To: <20071017.014211.41637735.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 17 Oct 2007 01:33:25 -0700 (PDT)
> 
> > sg_next() gives you a NULL after the last entry, but tests have been
> > changed to compare against sg_last() which is likely not what we
> > want for those checks.
> 
> This of course isn't true, ignore me as I'm still learning how this
> new stuff works :-)

Righto, it's invalid to call sg_next() on the last entry! Let me know if
you need any help with debugging this, unfortunately I cannot test on
sparc64 myself...

(I can say that easily, since I know that davem will a) not rest until
this is fixed, and b) is a really good debugger and will not need my
help)

-- 
Jens Axboe

