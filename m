Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C93CEC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 01:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLOBHT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Dec 2022 20:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiLOBHR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Dec 2022 20:07:17 -0500
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DA5537ED
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 17:07:17 -0800 (PST)
Received: by mail-qt1-f177.google.com with SMTP id ay32so3994037qtb.11
        for <linux-scsi@vger.kernel.org>; Wed, 14 Dec 2022 17:07:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VUz7hMzCsaHzdhxpH1nwZzUYCODeREAHtAXb+aH/eSM=;
        b=VvLiGw6QXwJuJZHZRSyv7H6n2ivNXffk6RQahsLyAvncY1YAWnNEnjVqL2aHQOTEe+
         vewOdIWHW7ei0t4Vas+bRa7EHLR2t5hlI2MOTB08Xg/4PaD4fI5EgN2TL+PcaZ2W0ZjD
         PabElq8sR9Krtoa2JdmXsdLVlTiFe3V2S/7CrMBLaPG67yvi+4hZ0aGHqXXSj7UIcBqY
         s9o1eqsISyH7xpT6SlTB/nbg7EhY6Y4xMZWnl9NjgKmkY7Dhu6zOBjD0/0RUkP/Ta4bi
         +GauwLVV3Vs0En7fvgKmzQf8UOy4eADFm2XfAW/pQ/uAv0jPeALeYee63kjgYBDs1otq
         dPAQ==
X-Gm-Message-State: ANoB5pnNqY2RIZfkCy8YsLkk+HU5QaYwopkFJM5V0g2PCfisRfJFQmYo
        i35Dd88nkyCUYaarnjvBpP0=
X-Google-Smtp-Source: AA0mqf6j5TEyVAr8EuIf3rIDEwPSkeqBEP9GaIx5Csf0wqGjMib0f8uUu0cnTCMx47Ts4/ULgcMUBQ==
X-Received: by 2002:ac8:66c7:0:b0:3a8:a84:7ffa with SMTP id m7-20020ac866c7000000b003a80a847ffamr23893464qtp.57.1671066436393;
        Wed, 14 Dec 2022 17:07:16 -0800 (PST)
Received: from [172.22.37.189] (rrcs-76-81-102-5.west.biz.rr.com. [76.81.102.5])
        by smtp.gmail.com with ESMTPSA id q15-20020ac8450f000000b003a6934255dasm2614706qtn.46.2022.12.14.17.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Dec 2022 17:07:15 -0800 (PST)
Message-ID: <b97c35f9-619d-13f0-c16b-be8ea023418e@acm.org>
Date:   Wed, 14 Dec 2022 15:07:12 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 0/3] Add support for UFS Event Specific Interrupt
Content-Language: en-US
To:     Can Guo <quic_cang@quicinc.com>, quic_asutoshd@quicinc.com,
        mani@kernel.org, stanley.chu@mediatek.com, adrian.hunter@intel.com,
        beanhuo@micron.com, avri.altman@wdc.com, junwoo80.lee@samsung.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <1670990763-30806-1-git-send-email-quic_cang@quicinc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1670990763-30806-1-git-send-email-quic_cang@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/22 20:05, Can Guo wrote:
> UFS Multi-Circular Queue (MCQ) driver is on the way. This patch series is
> to enable Event Specific Interrupt (ESI), which can used in MCQ mode.
> 
> Please note that this series is developed and tested based on the latest MCQ
> driver (v11) pushed by Asutosh Das.

Please add the following to the three patches in this series:


Reviewed-by: Bart Van Assche <bvanassche@acm.org>
