From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch 1/2]block: handle merged discard request
Date: Mon, 20 Aug 2012 09:58:54 -0400
Message-ID: <20120820135854.GA19254@infradead.org>
References: <CANejiEWecb58G--=mwez+A4Ra6nJ0qOHGMcJA-nOGH=jmGA3qQ@mail.gmail.com>
 <4F69C62C.7020604@kernel.org>
 <yq18vitwejt.fsf@sermon.lab.mkp.net>
 <CANejiEX26=jqijgTwb0iLMw7WC7byF1o+whwp3K5CcY5_a8o8w@mail.gmail.com>
 <yq1zkb9uz1t.fsf@sermon.lab.mkp.net>
 <20120620085724.GA26295@infradead.org>
 <yq1fw9o3t5b.fsf@sermon.lab.mkp.net>
 <CAMM=eLcBMrOfhJZU2GsSnMXkmWZMemJcvTM6WPLiiXkysXHYiQ@mail.gmail.com>
 <yq1wr0weu9q.fsf@sermon.lab.mkp.net>
 <20120820135739.GB28570@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37749
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754975Ab2HTN7D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2012 09:59:03 -0400
Content-Disposition: inline
In-Reply-To: <20120820135739.GB28570@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, Shaohua Li <shli@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk, linux-kernel@vger.kernel.org, neilb@suse.de, linux-scsi@vger.kernel.org

On Mon, Aug 20, 2012 at 09:57:39AM -0400, Mike Snitzer wrote:
> But I haven't put my finger on _why_ a discard bio has bio->bi_io_vec
> (but given my use of DM, bio comes from bio_alloc_bioset, and DM passes
> original bio->bi_max_vecs for nr_iovecs).

TRIM has a payload and we cheay by preallocation a data page for it.

