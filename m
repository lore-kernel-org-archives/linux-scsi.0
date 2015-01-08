From: Christoph Hellwig <hch@lst.de>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Thu, 8 Jan 2015 10:29:42 +0100
Message-ID: <20150108092942.GA11056@lst.de>
References: <CAADnVQ+wys8mD+QoMVsWAWWryfZBgxct_XFZM44Xoz_1dPUAuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:33419 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137AbbAHJ3r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Jan 2015 04:29:47 -0500
Content-Disposition: inline
In-Reply-To: <CAADnVQ+wys8mD+QoMVsWAWWryfZBgxct_XFZM44Xoz_1dPUAuA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sasha.levin@oracle.com>, bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>

On Wed, Jan 07, 2015 at 07:55:42PM -0800, Alexei Starovoitov wrote:
> I'm seeing the same splats... what tree I can pull the fix from ?

None so far.  I'll still need a review to apply it to the scsi-queue tree.
