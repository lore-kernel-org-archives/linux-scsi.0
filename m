From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] IB/srp: Fix a 32-bit compiler warning
Date: Thu, 6 Nov 2014 16:34:54 +0100
Message-ID: <20141106153454.GB22415@lst.de>
References: <545B8324.7010106@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57556 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046AbaKFPe5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Nov 2014 10:34:57 -0500
Content-Disposition: inline
In-Reply-To: <545B8324.7010106@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>, Wu Fengguang <fengguang.wu@intel.com>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On Thu, Nov 06, 2014 at 03:18:12PM +0100, Bart Van Assche wrote:
> The result of a pointer subtraction has type ptrdiff_t. Hence change a
> %ld format specifier into %td. This change avoids that the following
> warning is printed on 32-bit systems:
> 
> warning: format '%ld' expects argument of type 'long int', but argument 5 has type 'int' [-Wformat=]

Thanks.  Given that this is a new warning in the patches I merged I'll
add this one as well.
