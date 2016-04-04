From: Ming Lin <mlin@kernel.org>
Subject: Re: [PATCH v2 5/5] lib: scatterlist: move SG pool code from SCSI
 driver to lib/sg_pool.c
Date: Mon, 4 Apr 2016 13:29:17 -0700
Message-ID: <CAF1ivSaDHBGsjM_aC6hGQVROPLDKwbzB65AGbh2m5V24dekVKw@mail.gmail.com>
References: <1458684196-15923-6-git-send-email-mlin@kernel.org>
	<201603231036.A8dUuAli%fengguang.wu@intel.com>
	<CAF1ivSarDagJvHbOTG9yaOpjS9DufE9HLEr==UgE4en47LRuRA@mail.gmail.com>
	<20160404201701.GA5388@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:47388 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467AbcDDU3V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 16:29:21 -0400
In-Reply-To: <20160404201701.GA5388@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Apr 4, 2016 at 1:17 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Apr 04, 2016 at 01:15:45PM -0700, Ming Lin wrote:
>> cleanup_sdb:
>>         for (i = 0; i < SG_MEMPOOL_NR; i++) {
>>                 struct sg_pool *sgp = sg_pools + i;
>>                 if (sgp->pool)
>>                         mempool_destroy(sgp->pool);
>>                 if (sgp->slab)
>>                         kmem_cache_destroy(sgp->slab);
>>         }
>>
>> I'll keep the NULL check if no objection.
>
> I don't necessarily, but given that this is a code move I'd prefer
> to keep the code as similar as possible in the actual move patch..

So I'll just keep it.
And I can send a cleanup patch after this series applied.
