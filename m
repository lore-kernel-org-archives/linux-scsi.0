From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] mpt2/mpt3 static checker fixups
Date: Mon, 2 Jun 2014 09:33:07 -0700
Message-ID: <20140602163307.GE26828@infradead.org>
References: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:52097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaFBQdI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 12:33:08 -0400
Content-Disposition: inline
In-Reply-To: <1401719672-18352-1-git-send-email-joe.lawrence@stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: linux-scsi@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>

On Mon, Jun 02, 2014 at 10:34:28AM -0400, Joe Lawrence wrote:
> Hello Sreekanth, Dan,
> 
> These are a few minor smatch and sparse static checker fixes for the LSI
> mpt2 and mpt3 drivers.  The first three fix real potential bugs and the
> last cleans up a noisy complaint from sparse.

Can you check if any of these also applies to drivers/message/fusion?
There is tons of copy & paste between all three drivers unfortunately.

