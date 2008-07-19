From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] block: fix q->max_segment_size checking in
 blk_recalc_rq_segments about VMERGE
Date: Sat, 19 Jul 2008 00:28:26 -0700 (PDT)
Message-ID: <20080719.002826.73806419.davem@davemloft.net>
References: <20080717131444K.fujita.tomonori@lab.ntt.co.jp>
	<Pine.LNX.4.64.0807170746001.31185@devserv.devel.redhat.com>
	<20080717221908D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46196
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751299AbYGSH21 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jul 2008 03:28:27 -0400
In-Reply-To: <20080717221908D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fujita.tomonori@lab.ntt.co.jp
Cc: mpatocka@redhat.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org

From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Date: Thu, 17 Jul 2008 22:18:44 +0900

> BTW, as I've already said, I'm not against removing the vmerge
> accounting from the block layer.

I am also, as stated, not against this.

Fujita-san, please proposage a patch so that we can put this
issue behind us :-)
