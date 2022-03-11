Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 571DBC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Mar 2022 13:49:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348949AbiCKNuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Mar 2022 08:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240780AbiCKNuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Mar 2022 08:50:16 -0500
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6314916EA9E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2022 05:49:13 -0800 (PST)
Received: by mail-oo1-xc2f.google.com with SMTP id l24-20020a4a8558000000b00320d5a1f938so10546808ooh.8
        for <linux-scsi@vger.kernel.org>; Fri, 11 Mar 2022 05:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XssUXhxZdjdOvXENTe/aQygfbLESRgtzu3PY1NWc2dw=;
        b=hszVRV1ROqwuFTijB954IqqWTkDYMBi8RWjHmPtRTSChzFoJQYOx68K2kiH/wZRmU4
         QVeLkWIX10lmLMh0JS/VAp2cL5Hl7uiJjNCP3Q1sJJcecGnaRxvw0kPWaselGvbvzPle
         ilWUmjY/r5Shc16sP2i64dR1fC30eg/FDxMrc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XssUXhxZdjdOvXENTe/aQygfbLESRgtzu3PY1NWc2dw=;
        b=yoKZXAa7X0TUnJ5jd9nCa8/GE9SwrUI7rVjA7+QU7AZK8XDPNHG4kML+QkVR6XwV6u
         Bfpu2LZTYC26ZCg33qU4oUg0vE373i6/5I3KQgrBcJ8o52tf/M8tbMR5ztUsg/f5rNnG
         06rTH5QBZC6qG+BGrRbmHC1ShAEBH5sHYJ2xkpA/CU8yzCSXLMGtyFGmKSUasBeYo+e2
         1JT1OiQcZWXg53mKRjrEADnpsBZgFJhu+coR5pBdMyYC482JGAFkNMVrtya+Jhlsl8xy
         kjZOsIjdMg4hI8ZkT2qwDP46wvUzZaup0wgLDYibImuBNCz8ouFA3WRlPhQ/wGwelkpi
         bdqw==
X-Gm-Message-State: AOAM533t07bMABF3dP+Aer7zXli0uwo/15AZ965DdIJxn9f2SXdqiNpo
        4XB25YQ/wC8qI5w59vNOHB9Bu5N80UkcO/+MQIGcjQ==
X-Google-Smtp-Source: ABdhPJy9mWhHvJDhr5yLIDoilgc6BoSTGzhLIiSpYQrx/eBJS/wMgZa46nyju8fH8pFH75Q2aWIJ4i/PCd+BHfehgw0=
X-Received: by 2002:a05:6871:b2c:b0:da:b3f:2b2d with SMTP id
 fq44-20020a0568710b2c00b000da0b3f2b2dmr10830042oab.204.1647006552550; Fri, 11
 Mar 2022 05:49:12 -0800 (PST)
MIME-Version: 1.0
References: <d625deae-a958-0ace-2ba3-0888dd0a415b@ddn.com>
In-Reply-To: <d625deae-a958-0ace-2ba3-0888dd0a415b@ddn.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Fri, 11 Mar 2022 19:19:01 +0530
Message-ID: <CAK=zhgqWT-B_XsZOqY=6z+wYhvHt+E79xy1Mvf=vP4zuiWu6aw@mail.gmail.com>
Subject: Re: [PATCH] scsi: mpt3sas: page fault in reply q processing
To:     Matt Lupfer <mlupfer@ddn.com>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "MPT-FusionLinux.pdl@broadcom.com" <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008757f505d9f198fb"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000008757f505d9f198fb
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 8, 2022 at 8:57 PM Matt Lupfer <mlupfer@ddn.com> wrote:
>
> We encountered a page fault in mpt3sas on a LUN reset error path:
>
> [  145.763216] mpt3sas_cm1: Task abort tm failed: handle(0x0002),timeout(30) tr_method(0x0) smid(3) msix_index(0)
> [  145.778932] scsi 1:0:0:0: task abort: FAILED scmd(0x0000000024ba29a2)
> [  145.817307] scsi 1:0:0:0: attempting device reset! scmd(0x0000000024ba29a2)
> [  145.827253] scsi 1:0:0:0: [sg1] tag#2 CDB: Receive Diagnostic 1c 01 01 ff fc 00
> [  145.837617] scsi target1:0:0: handle(0x0002), sas_address(0x500605b0000272b9), phy(0)
> [  145.848598] scsi target1:0:0: enclosure logical id(0x500605b0000272b8), slot(0)
> [  149.858378] mpt3sas_cm1: Poll ReplyDescriptor queues for completion of smid(0), task_type(0x05), handle(0x0002)
> [  149.875202] BUG: unable to handle page fault for address: 00000007fffc445d
> [  149.885617] #PF: supervisor read access in kernel mode
> [  149.894346] #PF: error_code(0x0000) - not-present page
> [  149.903123] PGD 0 P4D 0
> [  149.909387] Oops: 0000 [#1] PREEMPT SMP NOPTI
> [  149.917417] CPU: 24 PID: 3512 Comm: scsi_eh_1 Kdump: loaded Tainted: G S         O      5.10.89-altav-1 #1
> [  149.934327] Hardware name: DDN           200NVX2             /200NVX2-MB          , BIOS ATHG2.2.02.01 09/10/2021
> [  149.951871] RIP: 0010:_base_process_reply_queue+0x4b/0x900 [mpt3sas]
> [  149.961889] Code: 0f 84 22 02 00 00 8d 48 01 49 89 fd 48 8d 57 38 f0 0f b1 4f 38 0f 85 d8 01 00 00 49 8b 45 10 45 31 e4 41 8b 55 0c 48 8d 1c d0 <0f> b6 03 83 e0 0f 3c 0f 0f 85 a2 00 00 00 e9 e6 01 00 00 0f b7 ee
> [  149.991952] RSP: 0018:ffffc9000f1ebcb8 EFLAGS: 00010246
> [  150.000937] RAX: 0000000000000055 RBX: 00000007fffc445d RCX: 000000002548f071
> [  150.011841] RDX: 00000000ffff8881 RSI: 0000000000000001 RDI: ffff888125ed50d8
> [  150.022670] RBP: 0000000000000000 R08: 0000000000000000 R09: c0000000ffff7fff
> [  150.033445] R10: ffffc9000f1ebb68 R11: ffffc9000f1ebb60 R12: 0000000000000000
> [  150.044204] R13: ffff888125ed50d8 R14: 0000000000000080 R15: 34cdc00034cdea80
> [  150.054963] FS:  0000000000000000(0000) GS:ffff88dfaf200000(0000) knlGS:0000000000000000
> [  150.066715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  150.076078] CR2: 00000007fffc445d CR3: 000000012448a006 CR4: 0000000000770ee0
> [  150.086887] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  150.097670] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> [  150.108323] PKRU: 55555554
> [  150.114690] Call Trace:
> [  150.120497]  ? printk+0x48/0x4a
> [  150.127049]  mpt3sas_scsih_issue_tm.cold.114+0x2e/0x2b3 [mpt3sas]
> [  150.136453]  mpt3sas_scsih_issue_locked_tm+0x86/0xb0 [mpt3sas]
> [  150.145759]  scsih_dev_reset+0xea/0x300 [mpt3sas]
> [  150.153891]  scsi_eh_ready_devs+0x541/0x9e0 [scsi_mod]
> [  150.162206]  ? __scsi_host_match+0x20/0x20 [scsi_mod]
> [  150.170406]  ? scsi_try_target_reset+0x90/0x90 [scsi_mod]
> [  150.178925]  ? blk_mq_tagset_busy_iter+0x45/0x60
> [  150.186638]  ? scsi_try_target_reset+0x90/0x90 [scsi_mod]
> [  150.195087]  scsi_error_handler+0x3a5/0x4a0 [scsi_mod]
> [  150.203206]  ? __schedule+0x1e9/0x610
> [  150.209783]  ? scsi_eh_get_sense+0x210/0x210 [scsi_mod]
> [  150.217924]  kthread+0x12e/0x150
> [  150.224041]  ? kthread_worker_fn+0x130/0x130
> [  150.231206]  ret_from_fork+0x1f/0x30
>
> This is caused by mpt3sas_base_sync_reply_irqs() using an invalid reply_q
> pointer outside of the list_for_each_entry() loop. At the end of the
> full list traversal the pointer is invalid.
>
> Move the _base_process_reply_queue() call inside of the loop.
>
> Signed-off-by: Matt Lupfer <mlupfer@ddn.com>
> Cc: stable@vger.kernel.org
> Fixes: 711a923c14d9 ("scsi: mpt3sas: Postprocessing of target and LUN reset")

Thanks for the patch.
Ack-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 511726f92d9a..76229b839560 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2011,9 +2011,10 @@ mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc, u8 poll)
>                                 enable_irq(reply_q->os_irq);
>                         }
>                 }
> +
> +               if (poll)
> +                       _base_process_reply_queue(reply_q);
>         }
> -       if (poll)
> -               _base_process_reply_queue(reply_q);
>  }
>
>  /**
> --
> 2.35.1
>

--0000000000008757f505d9f198fb
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIF00pni3cRWzc0WVjAuk
Xi7AbadCVcIcKQ1QN3WnvERvMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDMxMTEzNDkxMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAu1Cx8zvQbrM0NHtGpOTZLy7D9k3fGR2OOZxOu
JJM1dU6OdnII6S9Kkib9AcCbS4kE4E8ulVEtOfeGxe5S9zF9YgJBufPHgj83bd2AAQZyINDvMHw0
wOvTK9zfPmrWj3B/RI8Qp70kLJfny9A0YHtHSjqxNsIMY6gYb27vFHItSYJAytWB2JBhvNnMF/SY
GO9vtTVn3dCG+dVa25C7kovIR9OOehNl/TxXdklOPzlPAnCpPOmh58HAzqtZQEtHHhF7woKs6zD3
PqQSbtvIpBh613F6Kxe6HvWwZ3VY6bGAMWCE9z8TU73pNFDixAVBpCmQS/Yeesa0FCX34zO5if+u
--0000000000008757f505d9f198fb--
