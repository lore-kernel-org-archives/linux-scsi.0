Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BFA6C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 15:23:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B9D60E74
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 15:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236509AbhJZPZh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 11:25:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236187AbhJZPZg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Oct 2021 11:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635261792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AkpuDI1xqrOFfxjCnES39c8hUWyHSyRHa6KbkJwr754=;
        b=Ak9ZN6pLHpigtJhaPrUjVqMo6xSj0BNilNxO94F3vmj+k7tFA/LN6DLP43h6Q4PbWnWrSf
        8cMZpmDkN4Z4luFtTqoGJVs+xajUsGSkcPp3kyTRiIS/9YMGEeR/3Gkw2OROultCcGw+GR
        GaL1W18Dj9Oey0R/2AJr6S/dTuYyopU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-j-Pe4w1SPUGimPpyJ5z36A-1; Tue, 26 Oct 2021 11:23:08 -0400
X-MC-Unique: j-Pe4w1SPUGimPpyJ5z36A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2FC271006AA2;
        Tue, 26 Oct 2021 15:23:07 +0000 (UTC)
Received: from localhost (unknown [10.39.195.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3AC0A5F4E0;
        Tue, 26 Oct 2021 15:22:58 +0000 (UTC)
Date:   Tue, 26 Oct 2021 16:22:57 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 11/11] vhost: allow userspace to create workers
Message-ID: <YXgdUfV52ZuZo2CB@stefanha-x1.localdomain>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-13-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="3TF8DvIYw1i77WAN"
Content-Disposition: inline
In-Reply-To: <20211022051911.108383-13-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--3TF8DvIYw1i77WAN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 22, 2021 at 12:19:11AM -0500, Mike Christie wrote:
> +/* Caller must have device mutex */
> +static int vhost_vq_setup_worker(struct vhost_virtqueue *vq,
> +				 struct vhost_vring_worker *info)

It's clearer if the function name matches the ioctl name
(VHOST_SET_VRING_WORKER).

--3TF8DvIYw1i77WAN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmF4HVEACgkQnKSrs4Gr
c8iU0wgAj4ZtAHsGeZepIAqBVetF9MhIZn24Y2gIQ+ceP/XUd10zAwCFXhDAi+ZX
lzVQcExOuoEeLy9k6g56Y1UB7DiKa05Tq1ApspPWaPU1o04zpUekYzhi5NMk2Kas
zlhwaWaMhxboupvsX9UdADGWhcPLrH1vq/wMMsITdPscQC4qDSLOxGyPhpaiJj/k
Z3GQtd5QP01WbZ8BgvVGG3adyJ3zDMBP56WGhIWzL5Qw+mo2vN0TZeStbEvKpyQx
cB/wNe+dSUaoAJGesAsdtHOV1L5zGJHIywWujoRxgqe3bE2eityzmrV55T5X2D2m
IIxsl6jecWOVSCqQJC0w3dHGz1L3gg==
=TsdU
-----END PGP SIGNATURE-----

--3TF8DvIYw1i77WAN--

