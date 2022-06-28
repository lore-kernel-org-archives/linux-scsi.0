Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7E8FC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 17:41:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiF1Rl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiF1RlX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 13:41:23 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB33333EB8
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 10:41:21 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-fe023ab520so17974678fac.10
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 10:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YexeiJ1P0MztDjYb1iFS24F9o71PfEp0S97CTBHMtyg=;
        b=gYaDGpfIVSBGveRa7cBFNgorkQYJkBQHJDMXlQF95vh91/u1Mgpr63SIjC8Fx4hhhq
         e/iRpAs4HTLf7YWZhblwkSRmFhrHh6Xed9evWxUS5mtD+WyCC9zikbxiYPSZwKtNOXrJ
         6Aro8wZF3CHOmD1k7xXlghkDgh4o8yiYCpXa4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YexeiJ1P0MztDjYb1iFS24F9o71PfEp0S97CTBHMtyg=;
        b=UQ0xbLvWA2cdUG70RkvT4ng2RVhicVAqtLmgpXD0jxsf70ET6IrzwHFHkz8hIJqW3V
         X74L0NH8zYmvbXOMAe8w93q1EmEjbpWcH6RUagohzKWOLMIEwEQyCsbB75PzbJyrTOhV
         Q05YJ5+yhrm0ERuZk4OfcFm+ko2+h5fqX+d10qe4G/8G+ZNcautlEHN0ZeaNDn5/hmwa
         UAbrIhZ8tS0fod+dEQC1/1ptASEXuFF/SuEqQ/C7/EeaivHI1FXuC6Fcf9qcncRx5U1R
         gfynPudeKSfk/9z1fqcLdW3NLHy8UCuV4C5Yyy7JtOCSDn9xDE+nUr4Nn9Gttv9nTmwS
         JKog==
X-Gm-Message-State: AJIora/uRc1+YovTh8bAVml0wXTUCCCqA2iGfvtKddnhu0aGdz4Au0dD
        HznRYSsNQwGgxjA6PcjkPZ7ifn00D8fM+YExl5TbJA==
X-Google-Smtp-Source: AGRyM1tZqCQmo9pRU0OBdUG7XIuwKr4scMS92kE7ffGTHsuyFTUcFPVdo3G0MSMZZsCtU6+F2JkS8wjTnRh/HcCJUs8=
X-Received: by 2002:a05:6870:b48d:b0:101:c750:a4b0 with SMTP id
 y13-20020a056870b48d00b00101c750a4b0mr465878oap.204.1656438081108; Tue, 28
 Jun 2022 10:41:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220628074848.5036-1-sreekanth.reddy@broadcom.com>
 <20220628074848.5036-2-sreekanth.reddy@broadcom.com> <11cc137e-2b3e-2f0d-4aa8-b54ac49ad8e3@huawei.com>
In-Reply-To: <11cc137e-2b3e-2f0d-4aa8-b54ac49ad8e3@huawei.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Tue, 28 Jun 2022 23:11:10 +0530
Message-ID: <CAK=zhgrH3ajb-_XXBazMeDktYi27qTjNUck8PUD+sNFEuYYtBw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mpi3mr: Enable shared host tagset
To:     John Garry <john.garry@huawei.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000006ffd7705e2858b41"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000006ffd7705e2858b41
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 28, 2022 at 8:32 PM John Garry <john.garry@huawei.com> wrote:
>
> On 28/06/2022 08:48, Sreekanth Reddy wrote:
> > Enable shared host tagset to make sure that total outstanding
> > IOs count won't cross controller's can_queue.
> >
> > Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> > ---
> >   drivers/scsi/mpi3mr/mpi3mr_os.c | 2 ++
> >   1 file changed, 2 insertions(+)
> >
> > diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > index d8c195b..da85eda 100644
> > --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> > +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> > @@ -4321,6 +4321,8 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >       shost->max_channel = 0;
> >       shost->max_id = 0xFFFFFFFF;
> >
> > +     shost->host_tagset = 1;
> > +
>
> nit: any reason not to set the flag in the scsi_host_template instead?

There is no specific reason. Please let me know if I need to repost
the patch with the host_tagset flag set in the scsi_host_template.

>
> >       if (prot_mask >= 0)
> >               scsi_host_set_prot(shost, prot_mask);
> >       else {
>

--0000000000006ffd7705e2858b41
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIeT42rfTapjIHaBV09O
ILNRT7gF7ZsimSzxeHcES7OLMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDYyODE3NDEyMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB/zHvyJXLXz/uGf+Z8ivjybky18sUQJI2RpREZ
vOss+aFJWhWHGbuYHUume3tPDmDK5KMXBGbDTx/O4a8ol68h2MR51E3RPe9qkaS9qE7nQPZy+1uv
C7ksZHiXuIJRECPoBaWYsg50vO0yBuQ+8PVg+BjkCHIpFqVMWN7soW6um922UTCTJfNYS6mc4L6o
5wIWnjRSC1Xb3WAXSjSaLlakV/cwzfF+3fi0T9s+S2TI1G9NuePAzNuFdLGxf38deP9tolP/AXIn
WZ9LHlAQpteXZj956KOT2leEcY2Ou145v1XgtQApuox4nVTRLknWDp0O3mn8DwxqAz9nJMzYkwZ1
--0000000000006ffd7705e2858b41--
