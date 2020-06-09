Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED5EC433DF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 10:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54799207ED
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 10:21:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISTDQsil"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728614AbgFIKVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 06:21:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727005AbgFIKVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 06:21:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591698097;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eCYPJtMlD3Q2XApHLxzxPPaRUdw/iIbtCU02+WuBpI0=;
        b=ISTDQsilkYMfP9y5swlpHu9R7bBJR9pOJv4UjGdtNLVXGGP13CBtsyjSF9ZQSoHsGmdRdv
        paBlqlNUKEp4j+T6ToRbukD35UdJn907JCfmuz7WCAYna+1c5RHRbSLdGcQwyzejrXVHib
        9HjNng0rd91CyVITgxFkgHk4fXffW+0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-6uVPT82tMq2s2Mqpm47laA-1; Tue, 09 Jun 2020 06:21:25 -0400
X-MC-Unique: 6uVPT82tMq2s2Mqpm47laA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E61C58018A5;
        Tue,  9 Jun 2020 10:21:23 +0000 (UTC)
Received: from localhost (ovpn-115-52.ams2.redhat.com [10.36.115.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9D6C210013D6;
        Tue,  9 Jun 2020 10:21:20 +0000 (UTC)
Date:   Tue, 9 Jun 2020 11:21:19 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 05/17] vhost scsi: use target_parse_emulated_name
Message-ID: <20200609102119.GB92564@stefanha-x1.localdomain>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-6-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-6-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 03:35:52PM -0500, Mike Christie wrote:
> Use target_parse_emulated_name so the acl and SCSI names are
> properly formatted.
>=20
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/vhost/scsi.c | 69 +++++++++-------------------------------------=
------
>  1 file changed, 11 insertions(+), 58 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7fYp8ACgkQnKSrs4Gr
c8jVcwf/dCPPBFnjbBercpCQ+KQvH9cb46oCRgiAVI1ZmNntflqqRZ2Kyz+sg+jw
PyGBF1KQZ+mEVSinhIBPapi7Hqbn9kAHzrfyQZ8BUXOjT7NghRazIyiCdq8MxhoW
r4Y16YseuxyEeV67dYe88VFzH6Bv2LofJDBfItcKTBvSJPDG9yQllbeWCAOk4vby
NUVDr/W64qsczGGwXtOlTLIbqzt6FWOmrIbcqgbqivTWKpdD5FH4s+IKMhByO5JS
+yoD/TryxdmwCO+jCPVpD4rP/Qc/S62Dmo6l27bYJ/1pDsfxruss2ae0erWDZxam
eHNBNlQqEsws97RHGwLn0AkPIkBAOQ==
=rzYj
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--

