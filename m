From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC 1/2] scatterlist: add mempool based chained SG
	alloc/free api
Date: Mon, 21 Mar 2016 15:48:53 +0100
Message-ID: <20160321144853.GB12934@lst.de>
References: <1458081569-30953-1-git-send-email-mlin@kernel.org> <1458081569-30953-2-git-send-email-mlin@kernel.org> <20160316082339.GA6203@lst.de> <1458543317.4550.1.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:47139 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbcCUOsz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2016 10:48:55 -0400
Content-Disposition: inline
In-Reply-To: <1458543317.4550.1.camel@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Mar 20, 2016 at 11:55:17PM -0700, Ming Lin wrote:
> On Wed, 2016-03-16 at 09:23 +0100, Christoph Hellwig wrote:
> > >=A0
> > We can defintively kill this one.
>=20
> We want to support different size of pools.
> How can we kill this one?
>=20
> Or did you mean we just create a single pool with size SG_CHUNK_SIZE?

I mean just killing the SG_MEMPOOL_NR define and using the ARRAY_SIZE
directly.

> I created lib/sg_pool.c with CONFIG_SG_POOL.

Great!
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
