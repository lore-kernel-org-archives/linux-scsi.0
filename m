Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59115C00144
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Aug 2022 09:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiHAJfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Aug 2022 05:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiHAJfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Aug 2022 05:35:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037AA32EF5
        for <linux-scsi@vger.kernel.org>; Mon,  1 Aug 2022 02:35:45 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id x21so257546edd.3
        for <linux-scsi@vger.kernel.org>; Mon, 01 Aug 2022 02:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=EMKbttx5ynAzplQ+ZmcvHUaeklBVcrnfLbLDovv8/3Y=;
        b=LuHDs+y7/OjGIAEQFJgXvC1jca8nj94djTniNYXTJT6JIc/qOKNnleCYJQ4yZvfmHw
         kOOjEzwPC4Qih0AtEfcw5QQrSiVPn2cFkw3uz3j1SHJTHdubZaoNZGLqqpQtSVwRgo2c
         XoMOBDUiBKYzyBinDjaaran9pRyclloRy4hCe8L5DDsNJgt6Erkyv7n8F2K/7K+twvVB
         l2x7cqYZh2lcLhbLfk8iYwcjbG1QLmOmVLWeG/BrWN95GLoVCac1EttYbdfs12ARdrid
         79mhqcvl4iaLKAa/6o37ZY8NWytm2cLFISufZqkLJrjt+NG2ynhlXzeD7FXd+ahsdg6q
         0yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=EMKbttx5ynAzplQ+ZmcvHUaeklBVcrnfLbLDovv8/3Y=;
        b=rNm7M94Y3r/yxOtvp3TAXBdPF0X7LxJTLNoH1fdob1evrvV+V14b/jd5osAl78xBn2
         YzAiiukrIRFlPBRA/BRuXj8FPVUmbCicA0lAM6FjNXtiDa0vqox9GPbypthSSjE91cew
         NORzpcTeOu9974ZpdkOX3k2gzmMMpP5SuUDkbMsR4B4I4FAQ7bi0rIcRtscrnRJ0meUw
         rPni6r9z5K0NvyWN6O0R8iRKBpEgoo2ZoPXJYaQzgtS6MN/czleKWqaIofTsRK3LXLL/
         umDtCwiLumiIKr9jak+SmLbFo4ofCMmT7xwFFtE9LFe4dHC7ZmIreT7g7W1DIuskUHSZ
         L69Q==
X-Gm-Message-State: ACgBeo0rNpqcwq1/FqTEI6Y04s1sploskV4hE1U5EX27pNL+b+HTCDNl
        a1lrlRe/LlW0usJo80c5FhCWICTeJfkZdMY4Agan0Q==
X-Google-Smtp-Source: AA6agR7ewnSpbMEne9Lx5NzVVrOMwHSzHVXsw4be5pHt2k35zLXYZA0lgCm7lteJSHw6ajgYf36Q7uU5pXJ4cFqCxrk=
X-Received: by 2002:a05:6402:190b:b0:43d:d001:2cce with SMTP id
 e11-20020a056402190b00b0043dd0012ccemr912505edz.326.1659346543607; Mon, 01
 Aug 2022 02:35:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220722094612.78583-1-slark_xiao@163.com>
In-Reply-To: <20220722094612.78583-1-slark_xiao@163.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 1 Aug 2022 11:35:33 +0200
Message-ID: <CAMGffEnpVKB4z2zz-5WpneU3P3n4T7HO8A=su7yFPyX1WNyj2Q@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: Fix typo 'the the' in comment
To:     Slark Xiao <slark_xiao@163.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        jinpu.wang@ionos.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 22, 2022 at 11:46 AM Slark Xiao <slark_xiao@163.com> wrote:
>
> Replace 'the the' with 'the' in the comment.
>
> Signed-off-by: Slark Xiao <slark_xiao@163.com>
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 4acaff479916..91d78d0a38fe 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -3138,7 +3138,7 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
>   *
>   * when HBA driver received the identify done event or initiate FIS received
>   * event(for SATA), it will invoke this function to notify the sas layer that
> - * the sas toplogy has formed, please discover the the whole sas domain,
> + * the sas toplogy has formed, please discover the whole sas domain,
>   * while receive a broadcast(change) primitive just tell the sas
>   * layer to discover the changed domain rather than the whole domain.
>   */
> --
> 2.25.1
>
