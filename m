Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A77C47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 14:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1265613F1
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 14:32:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbhFCOeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 10:34:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230138AbhFCOd7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 10:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622730735;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yQeNSgxab343s13T8dhM9QnuIAZEWvIgxgspgrSno7w=;
        b=UbQgzxJszJkaBrV1NRpIC+vqd82F/r0sTPnCRnNev+awxZowQ3GWYBsUbVyMVU9Oh+oIUZ
        hh2no7uBzR2buRrwztyzaZaV07FlXUSy/3ukfw+CgsAJPPotgQD20b+ZNTWPeNYI3iX6NI
        Sf1gaI3M1CwVW42xat0O3g5jTDdN1W8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-KI1l-vCpOGuhs-KogWGDQQ-1; Thu, 03 Jun 2021 10:31:58 -0400
X-MC-Unique: KI1l-vCpOGuhs-KogWGDQQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE761107ACE6;
        Thu,  3 Jun 2021 14:31:56 +0000 (UTC)
Received: from localhost (ovpn-114-228.ams2.redhat.com [10.36.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2EA705D9F2;
        Thu,  3 Jun 2021 14:31:53 +0000 (UTC)
Date:   Thu, 3 Jun 2021 15:31:52 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 8/9] vhost: add vhost_dev pointer to vhost_work
Message-ID: <YLjn2Ht5WoPG4wup@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-9-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RZiem2OgOyGjJMdR"
Content-Disposition: inline
In-Reply-To: <20210525180600.6349-9-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--RZiem2OgOyGjJMdR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 01:05:59PM -0500, Mike Christie wrote:
> The next patch allows a vhost_worker to handle different devices. To
> prepare for that, this patch adds a pointer to the device on the work so
> we can get to the different mms in the vhost_worker thread.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c  |  7 ++++---
>  drivers/vhost/vhost.c | 24 ++++++++++++++----------
>  drivers/vhost/vhost.h |  4 +++-
>  drivers/vhost/vsock.c |  3 ++-
>  4 files changed, 23 insertions(+), 15 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--RZiem2OgOyGjJMdR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC459gACgkQnKSrs4Gr
c8gs3wf/XTDhzvGmFLjY39Te8DUMhO7QSZodoNYrGfc+qcC0icDBORmrE2HRAaST
fIjxQuantnSWIs7Lf6mO7h0J2aAc16AxzvtgUSP4idqwWNtVXibwk7wLLXEyPaHr
9XjMohaiUyWz5E7B8D24isDsirA2zYDQIEP/D6eiJrA00HVAwsex+zSI3zrr2tre
afpRecjqR3mhVEHaCpYcwmlcE03usH4L8iBhDxobZg5YWjRUvacuSdyqr2vkoGrH
dJgB8IpuzlNjLAFIFjFcJ/KXhtZ2GNAvn/6CXckki4zSAlvGQ3KMBKXNyEJkJmXO
KGmtBbA/gHy26xeLfaJ1Q4DiSov/zg==
=J4Wq
-----END PGP SIGNATURE-----

--RZiem2OgOyGjJMdR--

