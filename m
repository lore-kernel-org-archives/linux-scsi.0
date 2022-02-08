Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25EEFC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Feb 2022 06:32:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347453AbiBHGcf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 01:32:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347502AbiBHGcb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 01:32:31 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF96C0401F4
        for <linux-scsi@vger.kernel.org>; Mon,  7 Feb 2022 22:32:29 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id s21so20973924ejx.12
        for <linux-scsi@vger.kernel.org>; Mon, 07 Feb 2022 22:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qLC0AY2BcrvcKy6uLinNb7baq3XTSChUKFMo5Ii/YKY=;
        b=EmgsoAyMp/8PyEvw8ZjXJy6iPElrXu3e8YnfFuXmN3kU/RL3lFb2FxCKhk3yXQKVtd
         Oei5c3aGJXk5RgbYt82rKVMKaKkGtt9nr+ytXpfc9sQf3G42XRqrnoyKNtCbwSC+LmnD
         tAV294cXoT8OF8FOaLmLbY9dvmWBOp6tXtb37XHhmAtK6HlJkLZUfvD3fQwy9sAbJxpA
         kEIN8WTxOrOVgnoU0Zp2IVA/hchoW6luZDNXrIyQ+6ryJXctAxsj1om8pSZTRUcixeA2
         VjzESiW1G3Qxz4ObkAFGA/yjcdlw/L/is2De4je1IQyLqnDxoPJs9C1Gwp0LwMaUKyFa
         UCwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qLC0AY2BcrvcKy6uLinNb7baq3XTSChUKFMo5Ii/YKY=;
        b=OyS0vIacI8SRfsWxQnoQI14Z3/Ja72RRdXRDydwdm5kHcKL7DnE+wF+KjVf9YZhGR1
         J0bFjKXu5xJOP/yLJf9JoDtIFfRtn5hyDyouNj2Ocpg+Equ/cfssCSvW+MyS8dn6VZxL
         R7IYThtY+ZSvgb0DV9cOXH1G9/Q8x2r9yJnNcKDmVsNQnc2oOdCmvhL8MkQPFjNkZKhr
         h8HkVIacB9gWR0dQor21N/jDFBXsqRTk3gsYGFrXPo4/QMfE4AsADNtTQocmdKLcb8SB
         dqOzxUJ70xcFj0jbmDMCKO+F5sHm1NRS9c3m8YNK7aVLzCeFHck4X00BsrR+1zYiZc5g
         9e/g==
X-Gm-Message-State: AOAM530M2nYU49Rgnn9Rb+qDdC+2bowBDO4Xa26teJCsJSljyqtqFEo+
        BB+8sygiFBrsCdmMv576clWnc7BswAHmIhILtOZOOtwLZEA=
X-Google-Smtp-Source: ABdhPJwmjoHJ/OTaZvMEWv9Ybscc9QB33g5j0N/fhn/7vQAQWO5/E4tkaJG0Tk8jmDFhvpGMP13KQh9Z3oceoIlMWBs=
X-Received: by 2002:a17:907:3e9c:: with SMTP id hs28mr2397582ejc.735.1644301948202;
 Mon, 07 Feb 2022 22:32:28 -0800 (PST)
MIME-Version: 1.0
References: <20220208025500.29511-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220208025500.29511-1-yang.lee@linux.alibaba.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 8 Feb 2022 07:32:17 +0100
Message-ID: <CAMGffEnURrDMSJ44+LesZSxmgXewV4vRXBeD1c2-aBGDaaZEUA@mail.gmail.com>
Subject: Re: [PATCH -next v3] scsi: pm8001: clean up some inconsistent indentin
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        jinpu.wang@ionos.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 8, 2022 at 3:55 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Eliminate the follow smatch warning:
> drivers/scsi/pm8001/pm8001_ctl.c:760 pm8001_update_flash() warn:
> inconsistent indenting
>
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Thanks!
> ---
>
>   Changes in v3:
> --According to Damien's suggestion
>   1) "u32 fc_len = 0;" -> "u32 fc_len;".
>   2) Add spaces around the "-" and remove the unnecessary parenthesis.
>   3) Move "fc_len = (partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;"down,
>      right above the "if" where the variable is used.
>
>  drivers/scsi/pm8001/pm8001_ctl.c | 61 ++++++++++++++++----------------
>  1 file changed, 31 insertions(+), 30 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 41a63c9b719b..66307783c73c 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -727,6 +727,8 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>         u32             sizeRead = 0;
>         u32             ret = 0;
>         u32             length = 1024 * 16 + sizeof(*payload) - 1;
> +       u32             fc_len;
> +       u8              *read_buf;
>
>         if (pm8001_ha->fw_image->size < 28) {
>                 pm8001_ha->fw_status = FAIL_FILE_SIZE;
> @@ -755,36 +757,35 @@ static int pm8001_update_flash(struct pm8001_hba_info *pm8001_ha)
>                         fwControl->retcode = 0;/* OUT */
>                         fwControl->offset = loopNumber * IOCTL_BUF_SIZE;/*OUT */
>
> -               /* for the last chunk of data in case file size is not even with
> -               4k, load only the rest*/
> -               if (((loopcount-loopNumber) == 1) &&
> -                       ((partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE)) {
> -                       fwControl->len =
> -                               (partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
> -                       memcpy((u8 *)fwControl->buffer,
> -                               (u8 *)pm8001_ha->fw_image->data + sizeRead,
> -                               (partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE);
> -                       sizeRead +=
> -                               (partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
> -               } else {
> -                       memcpy((u8 *)fwControl->buffer,
> -                               (u8 *)pm8001_ha->fw_image->data + sizeRead,
> -                               IOCTL_BUF_SIZE);
> -                       sizeRead += IOCTL_BUF_SIZE;
> -               }
> -
> -               pm8001_ha->nvmd_completion = &completion;
> -               ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);
> -               if (ret) {
> -                       pm8001_ha->fw_status = FAIL_OUT_MEMORY;
> -                       goto out;
> -               }
> -               wait_for_completion(&completion);
> -               if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
> -                       pm8001_ha->fw_status = fwControl->retcode;
> -                       ret = -EFAULT;
> -                       goto out;
> -               }
> +                       /*
> +                        * for the last chunk of data in case file size is
> +                        * not even with 4k, load only the rest
> +                        */
> +
> +                       read_buf  = (u8 *)pm8001_ha->fw_image->data + sizeRead;
> +                       fc_len = (partitionSize + HEADER_LEN) % IOCTL_BUF_SIZE;
> +
> +                       if (loopcount - loopNumber == 1 && fc_len) {
> +                               fwControl->len = fc_len;
> +                               memcpy((u8 *)fwControl->buffer, read_buf, fc_len);
> +                               sizeRead += fc_len;
> +                       } else {
> +                               memcpy((u8 *)fwControl->buffer, read_buf, IOCTL_BUF_SIZE);
> +                               sizeRead += IOCTL_BUF_SIZE;
> +                       }
> +
> +                       pm8001_ha->nvmd_completion = &completion;
> +                       ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha, payload);
> +                       if (ret) {
> +                               pm8001_ha->fw_status = FAIL_OUT_MEMORY;
> +                               goto out;
> +                       }
> +                       wait_for_completion(&completion);
> +                       if (fwControl->retcode > FLASH_UPDATE_IN_PROGRESS) {
> +                               pm8001_ha->fw_status = fwControl->retcode;
> +                               ret = -EFAULT;
> +                               goto out;
> +                       }
>                 }
>         }
>  out:
> --
> 2.20.1.7.g153144c
>
