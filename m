From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
Date: Sun, 27 Jun 2010 21:32:07 +0900
Message-ID: <20100627212952D.fujita.tomonori@lab.ntt.co.jp>
References: <20100627185927K.fujita.tomonori@lab.ntt.co.jp>
	<20100627193253P.fujita.tomonori@lab.ntt.co.jp>
	<20100627110712.GA14511@lst.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:38589 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0F0Mcm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Jun 2010 08:32:42 -0400
In-Reply-To: <20100627110712.GA14511@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@lst.de
Cc: fujita.tomonori@lab.ntt.co.jp, snitzer@redhat.com, axboe@kernel.dk, dm-devel@redhat.com, James.Bottomley@suse.de, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org

On Sun, 27 Jun 2010 13:07:12 +0200
Christoph Hellwig <hch@lst.de> wrote:

> > How about this?
> 
> As I tried to explain before this utterly confuses the I/O completion
> path.  With the patch applied even a simple mkfs.xfs that issues discard
> just hangs.

Wired. I just tried mkfs.xfs against scsi_debug with my block patches
(I saw one discard command). Seemed that it worked fine.
