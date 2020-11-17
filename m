Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B56C64E7B
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 13:08:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93DE3221EB
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 13:08:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LYPUC89c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgKQNIF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 08:08:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21999 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729216AbgKQNID (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 08:08:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605618482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AgMbxMUBhWuyPsa8PpPPOK+LOWd1CJ56WBIRc5XYOME=;
        b=LYPUC89cjZhia2Fr/x6ZFowETS05eki86wH/RbVy/IrrBZra+VvIdF1agcOiRLu7pRlZZO
        McWQpPo17BLOIDXMsT7m/AbaI5kMqb9yjI3/Qg6tCVXOQ+/R+iWSfRBK8vHl/0K4+fmSyE
        RJ6Do8dGq6oq+44y6FgTgkFrVg41Z14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-xYSferWSMJGJO6_R-PunfA-1; Tue, 17 Nov 2020 08:07:57 -0500
X-MC-Unique: xYSferWSMJGJO6_R-PunfA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62BDE100749B;
        Tue, 17 Nov 2020 13:07:56 +0000 (UTC)
Received: from localhost (ovpn-115-113.ams2.redhat.com [10.36.115.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2A3F6EF51;
        Tue, 17 Nov 2020 13:07:52 +0000 (UTC)
Date:   Tue, 17 Nov 2020 13:07:51 +0000
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 03/10] vhost poll: fix coding style
Message-ID: <20201117130751.GM131917@stefanha-x1.localdomain>
References: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
 <1605223150-10888-5-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1605223150-10888-5-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=stefanha@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fDP66DSfTvWAYVew"
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--fDP66DSfTvWAYVew
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 12, 2020 at 05:19:03PM -0600, Mike Christie wrote:
> We use like 3 coding styles in this struct. Switch to just tabs.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  drivers/vhost/vhost.h | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--fDP66DSfTvWAYVew
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl+zyycACgkQnKSrs4Gr
c8iBFwgAj6yOsAzlghmcCCrVu68vX+WsP17kZuD3YNiOns9BH2qt8Ck6DNzZxhjK
h68yt2O4ggpB1ttLCN+jrnqrHXEfSqBS/bg9DxRf2OsLwmIKT0cGR8gXMwU+0g+1
tWXrULd/X6VuhPYbnrLJ0PDvnW2OVvUmYOGXG7J0DR8IL4Ubq/CJtL1GicNpwjAV
4+tSFKRRQFd9NFzzkVX9o8hGS7jH2dOoAl3m1s1wyIEwJa6tMwRTgZM9DNM2diq4
kfWLs1cXoyjBAAb9h4CMXr9Ns5x9BE8YQs86v3h99qrY+75INN49/UqMr7wA+97w
05bXLMLXQF6ssYfDRw5LPB3tJzl75w==
=/8zK
-----END PGP SIGNATURE-----

--fDP66DSfTvWAYVew--

