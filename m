From: Christoph Hellwig <hch@infradead.org>
Subject: Re: ultrastor.c
Date: Wed, 27 Apr 2005 09:11:06 +0100
Message-ID: <20050427081106.GA18086@infradead.org>
References: <20050427010406.67670997.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:47049 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261186AbVD0ILK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Apr 2005 04:11:10 -0400
Content-Disposition: inline
In-Reply-To: <20050427010406.67670997.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 27, 2005 at 01:04:06AM -0700, Andrew Morton wrote:
> 
> Is it just me, or did ultrastor get broken in 2.6.12-rc3?
> 
> drivers/scsi/ultrastor.c: In function `ultrastor_abort':
> drivers/scsi/ultrastor.c:948: `FAILURE' undeclared (first use in this function)
> drivers/scsi/ultrastor.c:948: (Each undeclared identifier is reported only once
> drivers/scsi/ultrastor.c:948: for each function it appears in.)
> 
> That's `make allmodconfig' on x86.
> 
> (FAILURE is not an option!)

Yes, it's my fault.  a patch has been posted to lkml long time ago, replacing
FAILURE with FAILED.

