Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E711C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Mar 2022 07:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235832AbiCGHgg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Mar 2022 02:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235792AbiCGHgg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Mar 2022 02:36:36 -0500
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9679B5F4FE
        for <linux-scsi@vger.kernel.org>; Sun,  6 Mar 2022 23:35:42 -0800 (PST)
Received: by mail-oo1-xc35.google.com with SMTP id k13-20020a4a948d000000b003172f2f6bdfso16706130ooi.1
        for <linux-scsi@vger.kernel.org>; Sun, 06 Mar 2022 23:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=36/Zqd3z+Se2yhH8jNVs3/MDJWsjnuLoRFR7LKykZoA=;
        b=EZHq6jmeKTJzZ/3AJ1Qp1+5s/njimkPglDfl92NVUtkLCINZW+pQD0VezeyS4iN7aM
         b5q4Echewcm2mjpOCEBYXFS0pZmAXmVWFbwrXT0HS2NHA3haiB0B6amzsHLg5fnHc8TA
         A2vE5nh24Vma/ZEyMgd7QoOk5+Mpc9HshcpK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=36/Zqd3z+Se2yhH8jNVs3/MDJWsjnuLoRFR7LKykZoA=;
        b=oYz64iNnJS8+7AJ5WXiMWfQXO3PQN8RGkCdh72jZelZHX808xyzUTeirYFQrZYfPua
         RRb3FCyb5VRew4s8PjmQO8BMCJsoSW6WZrggQlQm4V/OFz0yLhZyuy7EyLV2Ao4z62Xt
         9xcdMTtZiuMV0mPfnu45Vf73CywDia1jF7O5IRl0CuhDm8l6v7c8S5mgsonaugOwh0iS
         8z19Xu6bz03e/ljelmvsEp+kFxRi1TgyVa07sExmskOd1Y8U+/yE8sNvLbmJDaB7MqyC
         2IdRKCrU8KtuoHEMUp5BI69sf5gGMJsOGR1lEEj4B4Q+zLsnYI9nnmSFffOlvidIM+MB
         9WLQ==
X-Gm-Message-State: AOAM530QDM7U22CJpofthUEZK4OJtt+KTHaPq45XmWerIINdM1BSZ9qd
        qwFfUBwrkctLKiOizo/sS7QS+NBQkh2NY43tm245HA==
X-Google-Smtp-Source: ABdhPJyFblQWh5gDI1Jh8wN7aU4FeSmkwqaD+qh4O57ayCp1vM1wZ7FgbZLl8lxCOP9yK72U4ZmiO+nKlU2oQJNyl6o=
X-Received: by 2002:a05:6871:b2c:b0:da:b3f:2b2d with SMTP id
 fq44-20020a0568710b2c00b000da0b3f2b2dmr5184439oab.204.1646638541600; Sun, 06
 Mar 2022 23:35:41 -0800 (PST)
MIME-Version: 1.0
References: <20220224233056.398054-1-damien.lemoal@opensource.wdc.com> <20220224233056.398054-6-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220224233056.398054-6-damien.lemoal@opensource.wdc.com>
From:   Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Date:   Mon, 7 Mar 2022 13:05:30 +0530
Message-ID: <CAK=zhgosk4YHiKVriYAVNL8oApnA6MsEz9jvOo3imkCUpOpTRQ@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] scsi: mpt3sas: fix adapter replyPostRegisterIndex handling
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000005d44b805d99be93d"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--0000000000005d44b805d99be93d
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 25, 2022 at 5:01 AM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> The replyPostRegisterIndex array of struct MPT3SAS_ADAPTER is regular
> memory allocated from RAM, and not an IO mem resource. writel() should
> thus not be used to assign values to the array entries. Replace the
> writel() call modifying the array with direct assignements. This change
> suppresses sparse warnings.

writel() is a must here.  replyPostRegisterIndex array is having the
iommu address.
and here the driver is writing the data to these iommu addresses retrieved from
replyPostRegisterIndex array.

Thanks,
Sreekanth

>
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 37 ++++++++++++++++++-----------
>  1 file changed, 23 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 5efe4bd186db..4caa719b4ef4 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1771,10 +1771,13 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
>                  */
>                 if (completed_cmds >= ioc->thresh_hold) {
>                         if (ioc->combined_reply_queue) {
> -                               writel(reply_q->reply_post_host_index |
> -                                               ((msix_index  & 7) <<
> -                                                MPI2_RPHI_MSIX_INDEX_SHIFT),
> -                                   ioc->replyPostRegisterIndex[msix_index/8]);
> +                               unsigned long idx =
> +                                       reply_q->reply_post_host_index |
> +                                       ((msix_index  & 7) <<
> +                                        MPI2_RPHI_MSIX_INDEX_SHIFT);
> +
> +                               ioc->replyPostRegisterIndex[msix_index/8] =
> +                                       (resource_size_t *) idx;
>                         } else {
>                                 writel(reply_q->reply_post_host_index |
>                                                 (msix_index <<
> @@ -1826,14 +1829,17 @@ _base_process_reply_queue(struct adapter_reply_queue *reply_q)
>          * new reply host index value in ReplyPostIndex Field and msix_index
>          * value in MSIxIndex field.
>          */
> -       if (ioc->combined_reply_queue)
> -               writel(reply_q->reply_post_host_index | ((msix_index  & 7) <<
> -                       MPI2_RPHI_MSIX_INDEX_SHIFT),
> -                       ioc->replyPostRegisterIndex[msix_index/8]);
> -       else
> +       if (ioc->combined_reply_queue) {
> +               unsigned long idx = reply_q->reply_post_host_index |
> +                       ((msix_index  & 7) << MPI2_RPHI_MSIX_INDEX_SHIFT);
> +
> +               ioc->replyPostRegisterIndex[msix_index/8] =
> +                       (resource_size_t *) idx;
> +       } else {
>                 writel(reply_q->reply_post_host_index | (msix_index <<
>                         MPI2_RPHI_MSIX_INDEX_SHIFT),
>                         &ioc->chip->ReplyPostHostIndex);
> +       }
>         atomic_dec(&reply_q->busy);
>         return completed_cmds;
>  }
> @@ -8095,14 +8101,17 @@ _base_make_ioc_operational(struct MPT3SAS_ADAPTER *ioc)
>
>         /* initialize reply post host index */
>         list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
> -               if (ioc->combined_reply_queue)
> -                       writel((reply_q->msix_index & 7)<<
> -                          MPI2_RPHI_MSIX_INDEX_SHIFT,
> -                          ioc->replyPostRegisterIndex[reply_q->msix_index/8]);
> -               else
> +               if (ioc->combined_reply_queue) {
> +                       unsigned long idx =(reply_q->msix_index & 7) <<
> +                               MPI2_RPHI_MSIX_INDEX_SHIFT;
> +
> +                       ioc->replyPostRegisterIndex[reply_q->msix_index/8] =
> +                               (resource_size_t *) idx;
> +               } else {
>                         writel(reply_q->msix_index <<
>                                 MPI2_RPHI_MSIX_INDEX_SHIFT,
>                                 &ioc->chip->ReplyPostHostIndex);
> +               }
>
>                 if (!_base_is_controller_msix_enabled(ioc))
>                         goto skip_init_reply_post_host_index;
> --
> 2.35.1
>

--0000000000005d44b805d99be93d
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
0keLkvPdYw4wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPKBr2fYEZSevUMwkipQ
seJGSiBUf8c4HHqGmUmxXHkhMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMDMwNzA3MzU0MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCZqVZ0C3D/W5wvz0uKXBbCLXJEvHBs930oJHks
Wms6UDbMGWYnvZy0kvdkI7acwroqgfuB9Y4OiMM6GR2QDRvrW12LAc92v6FvjN1mVKFzap+aYV9b
HTvPxLYJN3AbfhlPUBvkRbsUw20i3wrhKpn0Kykr0H7MOt2x2QU0ftOO4saR3L8klfXxYEHNMlaT
cajUY7vaoBOF/iTh7WaYxAMOqaiqX7PXVuSIEcByKazeMbi4xdgerIGZsHWzWOEnrvPos1b3H8yU
5fLgYRIuxMjQOForTt4R18Q4UcBM6BwR3L4HGBxL+h35nlHTwX+skXWABggAI7c9krtMiNk0E4RJ
--0000000000005d44b805d99be93d--
