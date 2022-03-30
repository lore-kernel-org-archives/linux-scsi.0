Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC89CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Mar 2022 10:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245446AbiC3Klq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236516AbiC3Klo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Mar 2022 06:41:44 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086D126936A
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 03:40:00 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r13so40618939ejd.5
        for <linux-scsi@vger.kernel.org>; Wed, 30 Mar 2022 03:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BZjiD/QCGw6jNINKBc5oCFgT3nUNWLfrBNDmb/7Afs4=;
        b=GhslVlGBVTx2uyZjs5a0bTiYRE07myMIbYjhbAwT4SP2LBhvC69nUqrd1R1Y+CZ+f5
         BSEEZa8OdjTgeUwX+yd7pybBoHjLhWICAXxnJCS6ddmWbGkXa6+6joOxDb5xIgrKSxwM
         XcO/DTrCJdJtNE965+UC+dp5MTKHBmaM6ifMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BZjiD/QCGw6jNINKBc5oCFgT3nUNWLfrBNDmb/7Afs4=;
        b=zsvVo9z6IXIOR+Y+BkcXSTWUAnRguh9CjOgweOE1Umzaqu+2oUl8slr3nmkNrEPD1D
         o+C5JpQZB7qC5V/aF1I3Ibj1C3t6uSq/tm9z7SSULkcCGOH8CnNyQg+Nueh9dlQw7hpd
         u9v9IVzskwdnYRivG1MHG7qPMX/TTNEia9jqMCUkCRhplYhKJw3I7b9ROhJpGKJdbRtg
         crD1u6+WVvz7Bz4w9m/ASDCt/Zub3xpe/ReZZZ9AXZGr/uqNlxCNFII2UQww+mORytx4
         ddVm0WdDFIFWpdvqJWGdsKKAy1qkp85F1C64u4nu1bCp/O3qEoiCJEplKxqd0/zh7vaW
         o53g==
X-Gm-Message-State: AOAM531CzH/LZUG8dmSqicPHZ9J5pA1954z0YfaDUzfR6xUpo/zKqyCF
        PFQqS7fRrKpqV/sle5BNLOhi1zKe2JW1+SsmbkTmAdqTZrM=
X-Google-Smtp-Source: ABdhPJyLq8A4c0S3bZKNn9MmF3VgPKRS7mfZfglcpp7Tc0Hb5qH15JQbjgAhg17t/WY2/xeOLpEI9rSruMi8wMXB3QQ=
X-Received: by 2002:a17:906:87cd:b0:6df:b79f:e030 with SMTP id
 zb13-20020a17090687cd00b006dfb79fe030mr39237334ejb.632.1648636798483; Wed, 30
 Mar 2022 03:39:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220324094711.48833-1-chandrakanth.patil@broadcom.com> <Yjw+/LJiovLV9VhB@infradead.org>
In-Reply-To: <Yjw+/LJiovLV9VhB@infradead.org>
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Date:   Wed, 30 Mar 2022 16:09:47 +0530
Message-ID: <CABvwm=MshXxonajzsP4FMjTRpnvceLnfBivwUwuQzYEYYXUSmg@mail.gmail.com>
Subject: Re: [PATCH] megaraid_sas: device scan on logical target with invalid
 LUN ID deletes that target from the OS
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c0a49505db6d2afc"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000c0a49505db6d2afc
Content-Type: text/plain; charset="UTF-8"

Hi Christoph,

in shost, we set the max_lun to 8 during load and that is meant for
NON_RAID devices.
whereas RAID device supports only a single LUN so this patch takes care of that.

-ckp


On Thu, Mar 24, 2022 at 3:20 PM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Thu, Mar 24, 2022 at 02:47:11AM -0700, Chandrakanth patil wrote:
> > The megaraid_sas driver supports single LUN, that is LUN 0. And all other
> > LUNs are unsupported.
> > When a device scan on logical target with invalid lun is invoked through
> > sysfs that target itself is getting removed from the OS. So added a LUN
> > ID validation in the slave destroy to avoid the target deletion.
>
> Please set the max_lun member ins the host template isntead of papering
> over this in the driver.



-- 
Regards,
Chandrakanth Patil

--000000000000c0a49505db6d2afc
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDEsToCXmVAGrOZU9LzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMTAyMjIxMjM4MDJaFw0yMjA5MTUxMTIzMzVaMIGa
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGzAZBgNVBAMTEkNoYW5kcmFrYW50aCBQYXRpbDEuMCwGCSqG
SIb3DQEJARYfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAN17vAiN630Miz8/OedJKuauChEmiA4b0QYvWMA5eDpaTmonlWoaIrq6
FEwzCFLCgTpToIzUShYM1O6fu/b6Zdy1Jvdccbj7u7mSXWF+rKJu5yg2g38x2XxWsy+/4rwqi9ix
BSrtpRGbpSxMsfxuEvtMbzZCeC4SitvLhFIMMHgUJ9E8pxXV7c0/ub5jxd/3nIOeIDoTOqJgSn40
aBqT0QvScYPWy42jL2D449cgE9PMNQy1mrSwerDqgTTgZJM4gAW7ta1nFP8cNbLJNYn3ZFEhJnOw
pXRVGaqlwpA1hmodBANNyhMlODsRuxNuqmNzINouAr/YlO2bdzlu+VTWz0MCAwEAAaOCAeAwggHc
MA4GA1UdDwEB/wQEAwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9z
ZWN1cmUuZ2xvYmFsc2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
dDBBBggrBgEFBQcwAYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFs
c2lnbjJjYTIwMjAwTQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBz
Oi8vd3d3Lmdsb2JhbHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+
oDygOoY4aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcmwwKgYDVR0RBCMwIYEfY2hhbmRyYWthbnRoLnBhdGlsQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
KHtkFTCJhYaNrtTlVnhO7+Z49xswDQYJKoZIhvcNAQELBQADggEBAB695p3nxrHwDBiZuUyc4kSq
1o3jGWXYdAgZoVOXcGSn0FFSuBT4bkoZNRXvN4AZGh7n5XjtEzGQjn++xALKCRF6K3yFfhAqsrHx
66xXjz8VYmD4J4p+TzVo8GP7si+9xJO/AW4f0FMCQ3vJdruH1PMHZYYuHFHcgyDY5CagijMkFJtD
Zpnb0pToIvDm+Ur3N2MiX3nSNdXYjeMdwB0OAs05pMciX6VfrXagLKEdSRHtOo/W/JA7fToB0eJS
Ky1ZxnSRQGTL4yIIMw43kd0GQyTIM6KyMy8uprn32g7HcYJf07P/tjC196OWjB5Qr7dSv3vtjU8N
2J0Xc13/AGfXSZ8xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgxLE6Al5lQBqzmVPS8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHBUiFQ9
gei8WSTClsnAjpuYmdUlnS4Bey0lQVXLf/gCMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIyMDMzMDEwMzk1OFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQA8fibggREilE1swDxLrsk2CYjP
OWkZA29op/EvplGMv+uTvNuXYbS9lKVhwr2yWJUSq/nuqP5kqQ5u8OSh68o1wRnFBIoTSGlW+nEX
xuZ/1LrRhrruF41myU6yBShJ3ohuJufP0i1IaatTuBnIf1ylVpyjUvh7EPLdENJ8/tnldEgsVyYq
LRbnhFG8zQOGhQ15hAKSy95489tdVmr+5q7bMcy6iI9d/9EVdi34Lk9gXEQvPW6R+dJoxRV1jikH
Z5q7j9rt0Acddvb4emtZ/BGZOjKoUiiG10Qd9X6udPWaJ1xy/AVoXljjIAmuHd9gK9jh2eELFTig
fIZaaHaMbQcm
--000000000000c0a49505db6d2afc--
