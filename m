From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 5/5] lib: scatterlist: move SG pool code from SCSI
	driver to lib/sg_pool.c
Date: Mon, 4 Apr 2016 22:17:01 +0200
Message-ID: <20160404201701.GA5388@lst.de>
References: <1458684196-15923-6-git-send-email-mlin@kernel.org> <201603231036.A8dUuAli%fengguang.wu@intel.com> <CAF1ivSarDagJvHbOTG9yaOpjS9DufE9HLEr==UgE4en47LRuRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:57206 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756533AbcDDURD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 16:17:03 -0400
Content-Disposition: inline
In-Reply-To: <CAF1ivSarDagJvHbOTG9yaOpjS9DufE9HLEr==UgE4en47LRuRA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, lkml <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On Mon, Apr 04, 2016 at 01:15:45PM -0700, Ming Lin wrote:
> cleanup_sdb:
>         for (i = 0; i < SG_MEMPOOL_NR; i++) {
>                 struct sg_pool *sgp = sg_pools + i;
>                 if (sgp->pool)
>                         mempool_destroy(sgp->pool);
>                 if (sgp->slab)
>                         kmem_cache_destroy(sgp->slab);
>         }
> 
> I'll keep the NULL check if no objection.

I don't necessarily, but given that this is a code move I'd prefer
to keep the code as similar as possible in the actual move patch..
