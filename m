From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] gdth: scp timeout clean up (try #2)
Date: Wed, 7 Nov 2007 17:35:40 +0000
Message-ID: <20071107173540.GC25560@infradead.org>
References: <20071106065439.GA30397@us.ibm.com> <47301DA7.8000202@panasas.com> <20071106223453.GA5668@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53856 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbXKGRfl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Nov 2007 12:35:41 -0500
Content-Disposition: inline
In-Reply-To: <20071106223453.GA5668@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Achim_Leubner@adaptec.com, jens.axboe@oracle.com

On Tue, Nov 06, 2007 at 02:34:53PM -0800, malahal@us.ibm.com wrote:
> gdth driver is modified NOT to use scp->eh_timeout. Now, it has
> eh_timed_out (gdth_timed_out) to handle command timeouts for locked
> I/O's. Have not tested as I don't have needed hardware! Patch is
> against 2.6.23-mm1.

Looks good to me except for some tiny whitespace damage in the
host template.

It would be really useful if we could get some gdth devices for testing..

