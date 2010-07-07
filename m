From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: convert discard to REQ_TYPE_FS instead of REQ_TYPE_BLOCK_PC
Date: Wed, 7 Jul 2010 18:39:02 +0200
Message-ID: <20100707163902.GB11837@lst.de>
References: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:55562 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756661Ab0GGQjP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jul 2010 12:39:15 -0400
Content-Disposition: inline
In-Reply-To: <20100706160106C.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, snitzer@redhat.com, axboe@kernel.dk

Works for me with the OCZ SSD,


Reviewed-by: Christoph Hellwig <hch@lst.de>

