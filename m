Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBCAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 23:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbiCAXfI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Mar 2022 18:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiCAXfH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Mar 2022 18:35:07 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDA85EDCC
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 15:34:25 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id gm1so227136qvb.7
        for <linux-scsi@vger.kernel.org>; Tue, 01 Mar 2022 15:34:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n8lyo1Ou37YrvSIXmH5d4LvmDWvohcrt3ECdMXPa1SU=;
        b=r6nu3aVbYQjTDDNBu1VH8nkarYk2eF9b2PlLA64gIwoVYoigKf4gVlt7uv8Ughj1bK
         T/tSnAjQE4KB2F0hBM4WIBLhX1iPJPKhiu4QF7mGta6e3FSPJ470FHsMATbzJ5XzOPfJ
         34IWM9rMNhX8+/ZepDiYus3B1eapqIososWDWJaDGWNI4aMaM07wc0qjyqczVWOHETCm
         38rXqgYpxne2G5BVjjInoeDEmZD2AhRM6X4tObuYm8ELlCJvZfu9Txf4S8uwsTECOuV2
         UL2hv38oYqV63r5NeZpCU2RF4q2hm7F84GTD47deCJDJxIC6NUY/agI0r4JKlWJbWS3G
         rhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n8lyo1Ou37YrvSIXmH5d4LvmDWvohcrt3ECdMXPa1SU=;
        b=NrBai7dWCSkihrwAWd3apw252ZC/CzmOD/nduLV/C2ZHb1oykvsKS3YLWrzn7ubDF6
         vBQH4bom5OjJB739FDnQ35+Pw5Cl5Hysya72cuQGIXymNSx+Uw3AhPEkxlNgtlbMyPER
         fvhchK/JjWNYv04l9GXcuDoN8J41p5ZncC7MwAZcvfBpSRSV//PXd9v1VcCYjN4q0PJh
         vilIv7Cnp5OiRAcGd8rpfmjT3s21qjesJQE4Sz6P8grno42LWPqIe+KvxrUcMohWgVT0
         8LplI10Mdv121aJJevPjhzOgeJbpacNSuHuSdCRWEEEwYVAYQ1ddDCJZAHl6eTdUhY0O
         1vJw==
X-Gm-Message-State: AOAM532ntbE7MBOFDTcFpo7q1WYEF1fPGLq/AlAXoqUzUx6euKBV2U+p
        dUPir2IHZHeKSUWH2ksPsD/Z8p4umA6rgSc9WCp2UA==
X-Google-Smtp-Source: ABdhPJxT8ixyPUum5vHjaIh/ScO8V99UZmyY3ZhyUCg28dxyS2CE9ZonLh3Wc4MIGmPcKfy+vqYnRWVNC3A/hYI+jmc=
X-Received: by 2002:a05:6214:9c3:b0:432:c0c0:a6c3 with SMTP id
 dp3-20020a05621409c300b00432c0c0a6c3mr16032462qvb.43.1646177664600; Tue, 01
 Mar 2022 15:34:24 -0800 (PST)
MIME-Version: 1.0
References: <20220217181907.A2460E9317@localhost>
In-Reply-To: <20220217181907.A2460E9317@localhost>
From:   Khazhy Kumykov <khazhy@google.com>
Date:   Tue, 1 Mar 2022 15:34:13 -0800
Message-ID: <CACGdZYL8k46jTXvuu5AXzwZwQF2yj5WEwC_PTsN+f9mD6vUVmg@mail.gmail.com>
Subject: Re: [LSF/MM/BPF Topic][LSF/MM/BPF Attend] iscsi issue of scale with MNoT
To:     lduncan@suse.com
Cc:     lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f69c9205d9309a27"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000f69c9205d9309a27
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 17, 2022 at 10:19 AM <lduncan@suse.com> wrote:
>
> [RESEND -- apologies if you see this more than once]
>
> The iSCSI protocol continues to be used in Linux, but some of the
> users push the system past its normal limits. And using multipath just
> exacerbates that problem (usually doubling the number of sessions).
>
> I'd like to gather some numbers for open-iscsi (the standard Linux
> iSCSI initiator) and the kernel target code (i.e. LIO/targetcli) on
> what happens when there are MNoT -- massive numbers of targets.
>
> "Massive" in my case, will be relative, since I don't have access to
> a supercomputer, but I believe it will not be too hard to start
> pushing the system too far. For example, a recent user problem found
> that even at 2000 sessions using multipath, the system takes about 80
> seconds to switch paths. Each switch takes 80ms (and they are
> currently serialized), but when you multiply that by 1000 it adds up.
>
> For the initiator, I've long suspected some parts of the code were not
> designed for scale, so this might give me a chance to find and
> possibly address some of these issues.

There are some linear lookups (sess_list, conn_list) in the iSCSI
netlink which may be low hanging fruit, and do show up in heatmaps
when creating/destroying sessions/connections in the presence of 10k+
sessions in a machine. (Though this doesn't manifest 80s+ stalls,
thankfully)
>
> --
> Lee Duncan

--000000000000f69c9205d9309a27
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPmAYJKoZIhvcNAQcCoIIPiTCCD4UCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
ggzyMIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
ILTGVY3VZAH79IEwTAYDVR0gBEUwQzBBBgkrBgEEAaAyASgwNDAyBggrBgEFBQcCARYmaHR0cHM6
Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADCBmgYIKwYBBQUHAQEE
gY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2NhL2dzYXRsYXNy
M3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2Nh
Y2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgwFoAUfMwKaNei6x4schvRzV2V
b4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9jYS9nc2F0
bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEBAJ4mUVcBAENL0YI+c7NV9lED
+LdJalqdzPSczf76Imu8iFqQLRJE2f/oXC6rRCd4Re9dQWFTJrdG7FP8DvNo5gRcOY0cSQWeyh7x
kRxliZ1eOu4hjoH+JtrIIJBm40vHwDWc51MV1LuQJ6kA1/n5PyJsfYyPw4h5lInk3ZYVpkh6f4Oh
a1pUuyFRuqCOJ0r2IJcYVXrreMNOZfcjKtzZ290l5UZJtlKXS0qfeVdndP8ld3kdTYr4EcWiSI5l
qohmI3eIH5GaIMsagonJlBy+HTzwO5RW54p4DjsVMwcYB+82QFGOT2AZoIBeCYFXU2XB6t0Q8RoU
8Jg6o35bh+CWZ2UxggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIzIFNNSU1FIENBIDIwMjACEAEO
OfOqtlFUhIfo3Q6pjqUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIL5r8/JN03Qf
2AetgDe7PTZ4s7Ru98+ybg9lPYr0/SFqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTIyMDMwMTIzMzQyNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJ
YIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcN
AQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQC/t4XIXC/mPAj4TcN4vI8paU8SWUQB
XmpuKvcjMMGqyzygbH16ZqcRFixAlD6jrsr9ZLpvYVAhRNeqzF5t7itgbaRA9/qXYFzRM1bZzAYB
v4iZbGSjXgcHZmYrC3OHhfGWVf/qWyNcUGvbO4g7cZET9oNIL0T7XP2NkNris7XraDYnevA24tuP
lSQpCUjnJrl5m6uQnYhQbyBTrwTfDXyCsOMnmZJLJVDsWG93MwBGmrA/1pkhv1jR3G4qXDvZ9xAP
rb8B60dnr0CyAKHjp4PNkx3BYDh72NoO8srf6szJAy73Rkq+xKJQ2QVpNyWUOeTZK7knYIYzIJjM
77wFF+9I
--000000000000f69c9205d9309a27--
