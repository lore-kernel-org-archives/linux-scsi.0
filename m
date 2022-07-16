Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76E5C43334
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Jul 2022 13:36:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231934AbiGPNgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Jul 2022 09:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiGPNf7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2022 09:35:59 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF08D18B23
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 06:35:58 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-10bf634bc50so12402712fac.3
        for <linux-scsi@vger.kernel.org>; Sat, 16 Jul 2022 06:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=frN0d0JpqJ1OOChWS9n16npFK8fuQR8ZrpwQTlNbdbc=;
        b=LAjnCXrE4YOi58NolUfbtmDrI6K0MSeH9Wc5x8L+RMT+FOQiRsQQ7rh9NXqwE1ZnGy
         c0zVVBHe6U9jqdZZ7q2X1kEnWBE8gWnD4f4f2x7V65Ks7JhsuadX/CzIljZm09JsYGJ5
         1TnwtGR2f3jVypEC/preGSbxVk9jPRiXAnPLU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=frN0d0JpqJ1OOChWS9n16npFK8fuQR8ZrpwQTlNbdbc=;
        b=NmNj9Oc8R1XTem/0oZwkToC9oIlkR8GXipCjc0yzUIu2wYGfsUwO/uDTgXazqmppo+
         jkKaGcmwUMgdsF7VRba1d9cQkwDZXx34qLv1uZyjwgMarsbhrXSdUuLu86wXNST9Kzob
         lgEvhLZolV2GBs27eU2Tdwy8/LlO3mKHP/91GHsm7hyGIxHigjZ4zS1ku0TDp3XoDUCt
         JJrNiRyB39iRaM4Npx16Z0J0E0UiPywoLVNhlsyZVNyiWP3epwd1KKJrosbqqOi2kLys
         0+DL3LAFTjDCSBqynLk9Ijd9Nmfb1jbyNJVqhvrsS+NFKr0YoPSWyjXX0wJbiP0+eH7p
         XCPg==
X-Gm-Message-State: AJIora/OICCfargM8UQp6SG+/WPgEijrnCNRcAYY04NKzmlti9H3l2/Y
        SzvHh42f6wdqvnGeCr8miIHt+KBSLU9yQ902dibioAvClTTx9mYh
X-Google-Smtp-Source: AGRyM1uCtMXoQOc7ZA+gIcU3+SU9bvp3QtBSGA6+AxIJ76MHwroQVJxTETg8a+ilEB5P2YcKbmc+zng172IttvLXvC0=
X-Received: by 2002:aca:1b13:0:b0:322:4c21:6ba3 with SMTP id
 b19-20020aca1b13000000b003224c216ba3mr8739434oib.204.1657978557499; Sat, 16
 Jul 2022 06:35:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220715150219.16875-1-sreekanth.reddy@broadcom.com>
 <20220715150219.16875-2-sreekanth.reddy@broadcom.com> <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
In-Reply-To: <3a869ecf-bd82-2e72-2ec9-7b67a20c2d63@roeck-us.net>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Sat, 16 Jul 2022 19:05:46 +0530
Message-ID: <CAK=zhgogTnOgCwGytaay3fBJjuj1aw4ssOp-=nG75-2a-k3gkA@mail.gmail.com>
Subject: Re: [PATCH 1/1] mpi3mr: Fix compilation errors observed on i386 arch
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000fc063405e3ec3630"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000fc063405e3ec3630
Content-Type: text/plain; charset="UTF-8"

Hi Guenter,

Please check the changes below. I hope this change will work with
32-bit pointers as well.  If it looks good then I will post this
change as a patch.

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 0901bc932d5c..0bba19c0f984 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct
mpi3mr_ioc *mrioc,
                ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
                return;
        }
-       *(__le64 *)fwevt->event_data = (__le64)tg;
+       memcpy(fwevt->event_data, (char *)&tg, sizeof(void *));
        fwevt->mrioc = mrioc;
        fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
        fwevt->send_ack = 0;
@@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
        {
                struct mpi3mr_throttle_group_info *tg;

-               tg = (struct mpi3mr_throttle_group_info *)
-                   (*(__le64 *)fwevt->event_data);
+               memcpy((char *)&tg, fwevt->event_data, sizeof(void *));
                dprint_event_bh(mrioc,
                    "qd reduction event processed for tg_id(%d)
reduction_needed(%d)\n",
                    tg->id, tg->need_qd_reduction);

Thanks,
Sreekanth

On Fri, Jul 15, 2022 at 10:19 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On 7/15/22 08:02, Sreekanth Reddy wrote:
> > Fix below compilation errors observed on i386 ARCH,
> >
> > cast from pointer to integer of different size
> > [-Werror=pointer-to-int-cast]
> >
> > Fixes: c196bc4dce ("scsi: mpi3mr: Reduce VD queue depth on detecting throttling")
> > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > ---
> >   drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++---
> >   1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > index 0901bc932d5c..d8013576d863 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -386,7 +386,7 @@ static void mpi3mr_queue_qd_reduction_event(struct mpi3mr_ioc *mrioc,
> >               ioc_warn(mrioc, "failed to queue TG QD reduction event\n");
> >               return;
> >       }
> > -     *(__le64 *)fwevt->event_data = (__le64)tg;
> > +     memcpy(fwevt->event_data, (char *)&tg, sizeof(u64));
> >       fwevt->mrioc = mrioc;
> >       fwevt->event_id = MPI3MR_DRIVER_EVENT_TG_QD_REDUCTION;
> >       fwevt->send_ack = 0;
> > @@ -1660,8 +1660,7 @@ static void mpi3mr_fwevt_bh(struct mpi3mr_ioc *mrioc,
> >       {
> >               struct mpi3mr_throttle_group_info *tg;
> >
> > -             tg = (struct mpi3mr_throttle_group_info *)
> > -                 (*(__le64 *)fwevt->event_data);
> > +             memcpy((char *)&tg, fwevt->event_data, sizeof(u64));
>
> How is this expected to work on a system with 32-bit pointers ?
>
> Guenter
>
> >               dprint_event_bh(mrioc,
> >                   "qd reduction event processed for tg_id(%d) reduction_needed(%d)\n",
> >                   tg->id, tg->need_qd_reduction);
>

--000000000000fc063405e3ec3630
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
5AGo2E3pe+2yEgkxKvM2fnniZHUiSjbrfKk6nl9RIXPOKUP5HntZFdA5XuNYXWM+HPs3O0AJwBm/
VCZsZtkjVjxeBmTXiXDnxytdsHdGrHGymPfjJYatDu6d1KRVDlMCAwEAAaOCAd0wggHZMA4GA1Ud
DwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUu
Z2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggr
BgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3
Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4
aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmww
JwYDVR0RBCAwHoEcc3JlZWthbnRoLnJlZGR5QGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUClVHbAvhzGT8
s2/6xOf58NkGMQ8wDQYJKoZIhvcNAQELBQADggEBAENRsP1H3calKC2Sstg/8li8byKiqljCFkfi
IhcJsjPOOR9UZnMFxAoH/s2AlM7mQDR7rZ2MxRuUnIa6Cp5W5w1lUJHktjCUHnQq5nIAZ9GH5SDY
pgzbFsoYX8U2QCmkAC023FF++ZDJuc9aj0R/nhABxmUYErIze2jV/VO8Pj7TnCrBONZ/Qvf8G5CQ
X1hfOcCDBgT7eSvf9YRLaV935mB9/V+KYX8lT4E0lB4wQ0OLV8qUS9UuNoG2lCJ5UQTMrBgeUFFY
eKKhn+R91COmRlKGlaCdTtzKG5atS6dPnGEYUHjcpUvzejmJ5ghBk6P01HqSACsszDOzmBvdiOs+
Ux0xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxyeqr1
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBzZpc+tnxSF4/7TMOhN
iKzTOpGjD7cHArBNCe0LGcsUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDcxNjEzMzU1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQClnfvoo/2IXTaD+6+QBcG5V/1w54m9SqKCZ7Z1
KiGJVislhLLKLCADDeYn/wQy0F4B7WudTn6g7SA0xfsGY1t0f7irC16RmNiUBApBLvHyg1g72Ovk
qIJOBReaQIur2lQVTkRWFWpLX32Zj9Ta99cVybbYSkqIx1JDfAT00LhwoP1nurUTOeqchxvM6YJq
G8bgbj38G2IoqGgjtwGJmhjJjc4OR+WKn3q0+Nh16Fjpno8SaXgwMiUUnFij4RKiSYPxdEPB5mqF
ccMqc3cct3VMMnDoKcwTz/FXstfabMOgRV4W6LM1BeJsSBudSpzRmhj2xYWFq6uZW8ry78cEgePJ
--000000000000fc063405e3ec3630--
