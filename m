Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51008EE49A6
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Aug 2023 19:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjHUTzU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Aug 2023 15:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjHUTzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Aug 2023 15:55:19 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFB011F
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 12:55:17 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-51d95aed33aso4624007a12.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Aug 2023 12:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1692647716; x=1693252516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eHODIufbnuwNvzgvQHGm/W1L7WZK7VyHnjitbLRSOfQ=;
        b=ECdKsJIaDY8mYAOCu7++duAU5j+20akQbKY9Cz4RIVWAg0kB5bFzbf1MmAv3MnRxxg
         2fr8agBagTfv8iDS+HQb8PUOFtOqxnSAedB2a0mTtKeS8qlE2HMUSVf+HeXGx8Nkw0fs
         sBhEwtUCKBLrZ8M8f8BWi3F32u+VW75OxlfguZ+rbnhDWdCRGGQ2dc+o8sbICgpJLmPr
         elFaTwMd1RdY/6SWOTVV0eRbBsGUdVkLmxVMyNbx6/vOtbA6n+ZqWUjtMY7j2H1q6RE4
         AvzadKha8wxVSeO48nCYHMGPU/DAC2rn/uC7Y8CoWt8xnPe7p4XjCgW65Py4/ZaSFc1u
         IoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692647716; x=1693252516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eHODIufbnuwNvzgvQHGm/W1L7WZK7VyHnjitbLRSOfQ=;
        b=FAYUGjoeth3IYTIp9Py+9oN0lpUri7YDXHN+0vtl088Y5cXh998MlbSPRZ4SK1GsbY
         X0knSnw2i+hGHxUyUDuUz9JYtF1ttqVHyD52Wa/UR5+wdXwmFX5IocZL+BcB1DZTLQCK
         O6bycQ6T/U0YI6VfAPaNTgei53+xxXJ/jcycHQ7as+eaA4AUNVfMBPr79vah8Tp0Mb4u
         pi9S+jtUqx0OVd7K+7gb4nWAi/JQxRuv0Bu07xiAupMeV/KhuuBMX8PCEEZY0TpyDXPQ
         zxoLeIWGpjqYiczIO8dp9ZEjDsZLnCHK7GpRMm8xDa2aDUvg7rqHbiOf+J0iHXWvm++J
         PBEw==
X-Gm-Message-State: AOJu0YwKp8DVOcaxQ2oGdLQjELF2B/ldph4G7wx9CO99KjErZs2ZHK1F
        4hK30eWOuvior0qFS1KrNv48Ma6Wb0xRphTYHE83UOWaWIZN0RaP
X-Google-Smtp-Source: AGHT+IHpcacR+65lK0QtvUrOM1B+HCXuvqiFC2KyBeECPkljyaCq7+rk45xyQyeeBX92RprgjlMv++PeNak2wr1N4H8=
X-Received: by 2002:aa7:dcc4:0:b0:524:5e4c:2fa4 with SMTP id
 w4-20020aa7dcc4000000b005245e4c2fa4mr5069116edu.14.1692647716449; Mon, 21 Aug
 2023 12:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230818124700.49724-1-yuehaibing@huawei.com>
In-Reply-To: <20230818124700.49724-1-yuehaibing@huawei.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 21 Aug 2023 21:55:05 +0200
Message-ID: <CAMGffEnGLyHtzV5L1OTek27dy3eL+qLBP53nNB2n6ppOQ8k2dg@mail.gmail.com>
Subject: Re: [PATCH -next] scsi: pm8001: Remove unused declarations
To:     Yue Haibing <yuehaibing@huawei.com>
Cc:     jinpu.wang@cloud.ionos.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, john.garry@huawei.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Aug 18, 2023 at 2:47=E2=80=AFPM Yue Haibing <yuehaibing@huawei.com>=
 wrote:
>
> Commit 4fcf812ca392 ("[SCSI] libsas: export sas_alloc_task()")
> removed these implementations but not the declarations.
>
> Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm800=
1_sas.h
> index 953572fc0d9e..2fadd353f1c1 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -702,8 +702,6 @@ int pm8001_mpi_fw_flash_update_resp(struct pm8001_hba=
_info *pm8001_ha,
>                                                         void *piomb);
>  int pm8001_mpi_general_event(struct pm8001_hba_info *pm8001_ha, void *pi=
omb);
>  int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *=
piomb);
> -struct sas_task *pm8001_alloc_task(void);
> -void pm8001_free_task(struct sas_task *task);
>  void pm8001_tag_free(struct pm8001_hba_info *pm8001_ha, u32 tag);
>  struct pm8001_device *pm8001_find_dev(struct pm8001_hba_info *pm8001_ha,
>                                         u32 device_id);
> --
> 2.34.1
>
