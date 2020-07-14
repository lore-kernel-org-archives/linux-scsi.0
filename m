Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6AFC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 16:24:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78A4922464
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 16:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CWDQ/rL1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726602AbgGNQYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 12:24:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49032 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725931AbgGNQYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 12:24:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594743885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+FLEpEZDk8rISaWZvNwzXNsNJnARmS3TqRhR9UwaCUo=;
        b=CWDQ/rL1kC8lv9KFj2qIKV/ddK7jOQpL/H6z4U4O2tTLPhjQI4+hhBC0svkJthppIsBebo
        TC2h4hSAWoWJwRUFhar0k5LAym6YHWOvyhBIPXOK5hTXT+Fpc7YBIwx7+lqUXhykZPKgSu
        Jt/YfpmdAqYJZ5dMjexZXpRcr5VhvK8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-mrzt3_DMN1OGm-OpsLcevg-1; Tue, 14 Jul 2020 12:24:42 -0400
X-MC-Unique: mrzt3_DMN1OGm-OpsLcevg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 53D138027E3;
        Tue, 14 Jul 2020 16:24:41 +0000 (UTC)
Received: from linux-ws.nc.xsintricity.com (unknown [10.10.110.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4AE5E710A0;
        Tue, 14 Jul 2020 16:24:40 +0000 (UTC)
Message-ID: <95350d0a60d1e305e2053388ada2cbd3310684e3.camel@redhat.com>
Subject: Re: [PATCH v2 18/29] scsi: aic7xxx: aic7xxx_osm: Remove unused
 variable 'tinfo'
From:   Doug Ledford <dledford@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
Date:   Tue, 14 Jul 2020 12:24:37 -0400
In-Reply-To: <20200713074645.126138-19-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
         <20200713074645.126138-19-lee.jones@linaro.org>
Organization: Red Hat, Inc.
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31)
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=dledford@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-MF4GySdp1S1KOrSEiVRK"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--=-MF4GySdp1S1KOrSEiVRK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2020-07-13 at 08:46 +0100, Lee Jones wrote:
> Looks like none of the artifact from  ahc_fetch_transinfo() are used
> anymore.
>=20
> Fixes the following W=3D1 kernel build warning(s):
>=20
>  drivers/scsi/aic7xxx/aic7xxx_osm.c: In function
> =E2=80=98ahc_linux_target_alloc=E2=80=99:
>  drivers/scsi/aic7xxx/aic7xxx_osm.c:567:30: warning: variable =E2=80=98ti=
nfo=E2=80=99
> set but not used [-Wunused-but-set-variable]
>  567 | struct ahc_initiator_tinfo *tinfo;
>  | ^~~~~
>=20
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
> Cc: Doug Ledford <dledford@redhat.com>

FWIW, I can't seem to figure out how you got mine or Dan's email
addresses as related to this driver.  The MAINTAINERS file only lists
Hannes.  The driver Dan and I worked on was a different driver.  It was
named aic7xxx, but that was back in the 1990s.  It was renamed to
aic7xxx_old so that Adaptec could contribute this driver you are
currently patching back around 2001 or so.  And then maybe around 2010
or something like that, the aic7xxx_old driver that Dan and I worked on
was removed from the upstream source tree entirely.  So, just out of
curiosity, how did you get mine and Dan's email addresses to put on the
Cc: list for these patches?

> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/scsi/aic7xxx/aic7xxx_osm.c | 5 -----
>  1 file changed, 5 deletions(-)
>=20
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 2edfa0594f183..32bfe20d79cc1 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -564,8 +564,6 @@ ahc_linux_target_alloc(struct scsi_target
> *starget)
>  =09struct scsi_target **ahc_targp =3D
> ahc_linux_target_in_softc(starget);
>  =09unsigned short scsirate;
>  =09struct ahc_devinfo devinfo;
> -=09struct ahc_initiator_tinfo *tinfo;
> -=09struct ahc_tmode_tstate *tstate;
>  =09char channel =3D starget->channel + 'A';
>  =09unsigned int our_id =3D ahc->our_id;
>  =09unsigned int target_offset;
> @@ -612,9 +610,6 @@ ahc_linux_target_alloc(struct scsi_target
> *starget)
>  =09=09=09spi_max_offset(starget) =3D 0;
>  =09=09spi_min_period(starget) =3D=20
>  =09=09=09ahc_find_period(ahc, scsirate, maxsync);
> -
> -=09=09tinfo =3D ahc_fetch_transinfo(ahc, channel, ahc->our_id,
> -=09=09=09=09=09    starget->id, &tstate);
>  =09}
>  =09ahc_compile_devinfo(&devinfo, our_id, starget->id,
>  =09=09=09    CAM_LUN_WILDCARD, channel,

--=20
Doug Ledford <dledford@redhat.com>
    GPG KeyID: B826A3330E572FDD
    Fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--=-MF4GySdp1S1KOrSEiVRK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAl8N3EUACgkQuCajMw5X
L91QwA//el/KRYXqi4LScWD4EuamYdKhnWngV66Q6k420INwOgyIB8fW+w+UdBci
p0+hBw0PVeZsa6aK2seWm7ac1bc04isSBgUJBss6t/XZIie61T325hUEtva1HryB
ekcCgzq0qUNPNS6HsxAXvDgBZhESJxwWLCYYWfnWqEyvgKpOFGb/SlqqaxTK7jjz
4Bb3FIhMYxNzYm/99EGUc+tkth187j48JQ9tawfOQsiNyrILNoj1PpPHD5tqdDzY
sQMKWG5QZd7PbFZAL0BC8L0u8JfAGEcVK4b4vINmhmPdLcBXGVkHjMkQjp8rCDUD
qWBlitjSDMU+F1h6jLLefQq1I7OUimiH4tb99at4qXlB5GtGCU7AR35PZmFnJPQv
FTnNIL2JwaJc2vGyITEuc3LyqIJMhjvu8fQ2U/2McDSHplqbAd0mRWMM/Ytk2V+r
F5n6MxAvOaY7FJi5uF4DXnXvyg6yc74MRwgFATnZFMHB6cDFYvxZwnLTLzUQq76I
qzIl+ko4UW0dVLbpbmKbSYbtNa84rd1CvAGrStJ00F5XHWLX8J4+HfyHFBJKY6YQ
4XCHAp5qQMdxyliX4EPzn4K0pvva7ocyxStYykSaIe6LaPqcD1pUQdicoJwvcdkQ
aAa5L8XE9ZzgQ2bOU7g4tBxlYwsibLFdy4PyfocWqk3NxgI0k5w=
=qSbG
-----END PGP SIGNATURE-----

--=-MF4GySdp1S1KOrSEiVRK--

