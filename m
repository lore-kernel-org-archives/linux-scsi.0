From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 0/5] mempool based chained scatterlist alloc/free api
Date: Wed, 23 Mar 2016 08:40:12 +0100
Message-ID: <20160323074012.GA17929@lst.de>
References: <1458684196-15923-1-git-send-email-mlin@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458684196-15923-1-git-send-email-mlin@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 22, 2016 at 03:03:11PM -0700, Ming Lin wrote:
> From: Ming Lin <ming.l@ssi.samsung.com>
>=20
> The fist 4 patches make the SG related definitions/structs/functions
> in SCSI code generic and the last patch move it to lib/sg_pool.c.
>=20
> I still keep the macro "SG_MEMPOOL_NR" since it's used in 3 places.

I don't =D1=95ee the point, but I'm not going to block the series over
it either.

The new series looks really nice to me!

Reviewed-by: Christoph Hellwig <hch@lst.de>
