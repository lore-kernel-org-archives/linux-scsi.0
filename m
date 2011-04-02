From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sat, 2 Apr 2011 09:36:43 -0400
Message-ID: <20110402133643.GB18990@infradead.org>
References: <20110401202051.GL4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33267 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab1DBNgo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Apr 2011 09:36:44 -0400
Content-Disposition: inline
In-Reply-To: <20110401202051.GL4183@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Apr 01, 2011 at 04:20:51PM -0400, Matthew Wilcox wrote:
> 
> In preparation for moving some drivers out from under the host_lock,
> make cmd_serial_number an atomic.

The right fix is to stop abusing cmd_serial_nubmer in those few
drivers, and use a driver-private and more scalable lookup data
structure than a linear list search.

And yes, I promised to at least move cmd_serial_number into these
drivers long time ago - time to get back to that.

