From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] allow drivers to hook into watchdog timeout
Date: Thu, 22 Jan 2004 13:59:09 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040122135909.B11283@infradead.org>
References: <20040120132052.GA6740@lst.de> <20040120155320.GA1478@beaverton.ibm.com> <20040120160058.GA8924@lst.de> <20040120164711.GA1628@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([213.86.99.234]:21769 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266234AbUAVN7O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Jan 2004 08:59:14 -0500
Content-Disposition: inline
In-Reply-To: <20040120164711.GA1628@beaverton.ibm.com>; from andmike@us.ibm.com on Tue, Jan 20, 2004 at 08:47:11AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, James.Bottomley@steeleye.com, gibbs@scsiguy.com, linux-scsi@vger.kernel.org

On Tue, Jan 20, 2004 at 08:47:11AM -0800, Mike Anderson wrote:
> I assume the wrapper would only help if we went the direction of having
> the LLDD call __scsi_done directly under some recovery case?

That's the case we'd use it for.  Whether it's a good thing is a different
question.  At least with the current SCSI code it probably creates more
problems than it could solve.  This whole thread is really just trying to
fish for the requirement from the driver writers.  And the maintainers of
the driver that could benefit from those unfortunately didn't answer yet..

