Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76F68C4320E
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 14:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DCB761155
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 14:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbhHEOSV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 10:18:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24463 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240209AbhHEOSU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 10:18:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628173085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CgTtaO9aoRpCiTYl9JW5StPBedgaEjV6BwrhWwCNWbE=;
        b=hu4J1kPqtC8FikAf1YwV+Q8Dg5cRpDwYUgwM36zCVQWXlM0AsYNmQn5XSpVlPLvWVGUpvI
        fZyP65EobiVoFKfGxVMWZlCHPEMs66Tg/quuwb8lgJg8N0etO96osaZv/98uqltWl/sElU
        dDF1unnCYj5kYXZ2nKiI2CPOTNC1/Zs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-121-c6z6JEHGMJe0DH8ARyr-fg-1; Thu, 05 Aug 2021 10:18:04 -0400
X-MC-Unique: c6z6JEHGMJe0DH8ARyr-fg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F369693925;
        Thu,  5 Aug 2021 14:18:00 +0000 (UTC)
Received: from localhost (unknown [10.39.193.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A98375D6A1;
        Thu,  5 Aug 2021 14:17:52 +0000 (UTC)
Date:   Thu, 5 Aug 2021 15:17:51 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Geoff Levand <geoff@infradead.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Song Liu <song@kernel.org>, Mike Snitzer <snitzer@redhat.com>,
        Coly Li <colyli@suse.de>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        linux-um@lists.infradead.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 08/15] virtio_blk: use bvec_virt
Message-ID: <YQvzD4FlF7+AgrSw@stefanha-x1.localdomain>
References: <20210804095634.460779-1-hch@lst.de>
 <20210804095634.460779-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZDhkEMoj7rmqL+Fh"
Content-Disposition: inline
In-Reply-To: <20210804095634.460779-9-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--ZDhkEMoj7rmqL+Fh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 04, 2021 at 11:56:27AM +0200, Christoph Hellwig wrote:
> Use bvec_virt instead of open coding it.
>=20
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/virtio_blk.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ZDhkEMoj7rmqL+Fh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmEL8w8ACgkQnKSrs4Gr
c8jPdgf+PcMouWs94g0uS6wpaN9fVvtvzsyRrLa0a4jPqggbtSulcjUYQzYZ9BGX
1xnrp3ABDt4KhYhX+iAsAxc4LmWEAYUruE6WxqsxaPKE19XcFuwM/tpwcv5U8/x+
2GvsXderla2RbbwTzdCFUf1m538Dw+eqH8+6Dt0Q6QjCC4EAX3ubWU+pX0K5rLNX
d7M7JCyOzOdU/VJYYVQDs1Vkpu/2AFtQT+hnq7veWzgQD+iFkLNZUEBVFm4jRbkC
5cfC+IUVtDkCjhD2offyhX+djtvDy5IZAnHEMv/ulIMmCzc0o1VgEy/5zNiKnjgg
5CdxbrfAKcA734P4gNIy/UD+hGlM6g==
=Cztj
-----END PGP SIGNATURE-----

--ZDhkEMoj7rmqL+Fh--

