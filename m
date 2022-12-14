Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41663C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Dec 2022 07:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237523AbiLNH6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 02:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiLNH6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 02:58:33 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E1719002
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 23:58:31 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b13so9114085lfo.3
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2022 23:58:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IxbZfUX4Nviy2hkrnnLbmVIHwHlHZcn2MbIH9zexpUk=;
        b=H9WDt10qJjs2cBZT6XSXiTJWLZMoz6qX48YI+0Kd7TqWXYQpMVkI+Kn5KcSrxyZOao
         LHIZPGZOH9jT+ldsqg/RRe30t1tM16c87zVt/1rKsHqvLAxYOM64WnnZyHesgPbZxfMo
         U7aAW7NPzylr0tmwzqqedwbAUHBqKNd6LwnpKUY2eeOmULqRFo6SZb/MNqgb+HrBcppU
         1haLc6/p/B7dE/AHVoeHRm6+9sXjP66iI1q+FsdEbG2IcI7I8v0vs+awWpCAA456IBb6
         SCcSS4fV8BxomgRKHJPbGa75ND1uNilOODYQ6olLK5nPtGhmqzCYIao3KFiI7a5kLYt3
         xjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IxbZfUX4Nviy2hkrnnLbmVIHwHlHZcn2MbIH9zexpUk=;
        b=2DX4VYLdp04YmwAHxGJz5hCi4GddCzFesvSjCplja9jsULq5Ksq8iQv3KYsspufEf1
         vTFdtI7wlWqM/XR0VN7C16jP3I7XCZEwHpZxroz+j45nMH1rxZu8btVHasoqPUedEbUL
         xnvGdONU/MOMxO9nl6ggupWJxKVSrf+8lFwW7GI4ZfEZllDJDXZAhW82Tx6+nj/A2oI/
         sBL01GxzS/rARKAoy5+Tz4PU8LO4dJWZq6DUInwNLvdfB/p/GB4ENSkWbR0852TRSVfq
         9fbIQinYUQ3ux2mmgt1HehwispCfkVOCgymam9NDCccUlwzncfqkPSoKHWIsrKHYa77H
         4Y2Q==
X-Gm-Message-State: ANoB5pkxZbiHjWBB6y/aaK1mKDN8rbMrSzSZjr31VTi89aXhJH7QqVPH
        tSr99tfbSD0lGaAk3sCjduTZ8ENd8knGuJlN1qPuSQ==
X-Google-Smtp-Source: AA0mqf4OLKkq8EY0zPxRzIQaqosp54e626Hd6YkXGe5GoIlUp8sAALoKfmaz6MS+1KXPIvbWLNTWdHqvuiOdlWNNj9M=
X-Received: by 2002:ac2:41d4:0:b0:4af:cd2:f8d5 with SMTP id
 d20-20020ac241d4000000b004af0cd2f8d5mr34231283lfi.489.1671004710341; Tue, 13
 Dec 2022 23:58:30 -0800 (PST)
MIME-Version: 1.0
References: <20221214070608.4128546-1-yanaijie@huawei.com> <20221214070608.4128546-3-yanaijie@huawei.com>
In-Reply-To: <20221214070608.4128546-3-yanaijie@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Wed, 14 Dec 2022 08:58:19 +0100
Message-ID: <CAMGffEmU_CNb2XMg47EkJ51VpWj1fU454Y0Bnn-fj4NQiM2cTA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] scsi: libsas: change the coding style of sas_discover_sata()
To:     Jason Yan <yanaijie@huawei.com>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com, john.g.garry@oracle.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 14, 2022 at 7:45 AM Jason Yan <yanaijie@huawei.com> wrote:
>
> The coding style where calling this interface is inconsistent with other
> interfaces for SATA devices. The standard style for other SATA interfaces
> is like:
>
>     #ifdefine CONFIG_SCSI_SAS_ATA
>     void sas_ata_task_abort(struct sas_task *task);
>     #else
>     static inline void sas_ata_task_abort(struct sas_task *task)
>     {
>     }
>     #endif
>
> And the callers does not have to do things like "#ifdefine CONFIG_SCSI_SAS_ATA"
> and may call the interface directly. So follow the standard style here.
>
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/libsas/sas_discover.c | 6 ------
>  include/scsi/libsas.h              | 1 -
>  include/scsi/sas_ata.h             | 9 +++++++++
>  3 files changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
> index d5bc1314c341..72fdb2e5d047 100644
> --- a/drivers/scsi/libsas/sas_discover.c
> +++ b/drivers/scsi/libsas/sas_discover.c
> @@ -455,14 +455,8 @@ static void sas_discover_domain(struct work_struct *work)
>                 break;
>         case SAS_SATA_DEV:
>         case SAS_SATA_PM:
> -#ifdef CONFIG_SCSI_SAS_ATA
>                 error = sas_discover_sata(dev);
>                 break;
> -#else
> -               pr_notice("ATA device seen but CONFIG_SCSI_SAS_ATA=N so cannot attach\n");
> -               fallthrough;
> -#endif
> -               /* Fall through - only for the #else condition above. */
>         default:
>                 error = -ENXIO;
>                 pr_err("unhandled device %d\n", dev->dev_type);
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 1aee3d0ebbb2..159823e0afbf 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -735,7 +735,6 @@ void sas_unregister_domain_devices(struct asd_sas_port *port, int gone);
>  void sas_init_disc(struct sas_discovery *disc, struct asd_sas_port *);
>  void sas_discover_event(struct asd_sas_port *, enum discover_event ev);
>
> -int  sas_discover_sata(struct domain_device *);
>  int  sas_discover_end_dev(struct domain_device *);
>
>  void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
> diff --git a/include/scsi/sas_ata.h b/include/scsi/sas_ata.h
> index 9c927d46f136..7cdba456b746 100644
> --- a/include/scsi/sas_ata.h
> +++ b/include/scsi/sas_ata.h
> @@ -36,8 +36,11 @@ void sas_ata_device_link_abort(struct domain_device *dev, bool force_reset);
>  int sas_execute_ata_cmd(struct domain_device *device, u8 *fis,
>                         int force_phy_id);
>  int smp_ata_check_ready_type(struct ata_link *link);
> +int sas_discover_sata(struct domain_device *dev);
>  #else
>
> +#define SAS_ATA_DISABLED_NOTICE \
> +       pr_notice_once("ATA device seen but CONFIG_SCSI_SAS_ATA=N\n")
>
>  static inline int dev_is_sata(struct domain_device *dev)
>  {
> @@ -103,6 +106,12 @@ static inline int smp_ata_check_ready_type(struct ata_link *link)
>  {
>         return 0;
>  }
> +
> +static inline int sas_discover_sata(struct domain_device *dev)
> +{
> +       SAS_ATA_DISABLED_NOTICE;
> +       return -ENXIO;
> +}
>  #endif
>
>  #endif /* _SAS_ATA_H_ */
> --
> 2.31.1
>
