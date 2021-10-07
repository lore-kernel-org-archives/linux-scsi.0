Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9966DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F44A61077
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Oct 2021 21:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbhJGVfe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Oct 2021 17:35:34 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:41882 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbhJGVfe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Oct 2021 17:35:34 -0400
Received: by mail-pg1-f181.google.com with SMTP id v11so1063450pgb.8
        for <linux-scsi@vger.kernel.org>; Thu, 07 Oct 2021 14:33:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5xcXKRwZ74WR4JglJVNYWwS1t0rAzIU9zzht+d5mX6E=;
        b=S8o612rPD0qairuA+eZH3OcI6ODHeoy7PxvGa6fx8QLAhopFk+pKM81e4ZBUIHdGH3
         B6gtCeH4ewnVvd0NMVEMNDr7GNuQjXk4wLNgY1aAv+4IVnBANbLGObcu6VojIGhFbeLK
         dL8MM0Tk0lMfIJvmx1eEY5Z87qyj1m05amsg+OP14wavXSe7nCQpleDIhAFYNOxXQwq/
         T1z9Y9CTMNlkYv5CAj7Y+d6/x+cTV6LQXf5JybEODIWsvZvYdOqghj5/e9G4cbCQ0q60
         7AtuGrwSdswYeK8Ue7zxXHfIgE98Blx9XivtYyO+Q7LgAdVA3YP2tfdrx7fc2RrmlGXG
         bfsg==
X-Gm-Message-State: AOAM531Az0rzQp1HgCJ1lajpb8ykblVqtQNdVU+nYZ/pvJi1ctP2iL5f
        CMwwK2RgQyuVJ0hhJqBeAXs=
X-Google-Smtp-Source: ABdhPJznWN/gFns76NicobUTqxQRAqLnrjdXdqVZq43YfLWxFv2HWCAKC9SCQ68zvHrbN82NK1N1/w==
X-Received: by 2002:a63:4464:: with SMTP id t36mr1601545pgk.4.1633642419748;
        Thu, 07 Oct 2021 14:33:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:ae88:8f16:b90b:5f1d])
        by smtp.gmail.com with ESMTPSA id e7sm343158pfc.114.2021.10.07.14.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 14:33:38 -0700 (PDT)
Subject: Re: [PATCH v4] scsi: ufs: support vops pre suspend for mediatek to
 disable auto-hibern8
To:     peter.wang@mediatek.com, stanley.chu@mediatek.com,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        avri.altman@wdc.com, alim.akhtar@samsung.com, jejb@linux.ibm.com
Cc:     wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        jonathan.hsu@mediatek.com, qilin.tan@mediatek.com,
        lin.gui@mediatek.com, mikebi@micron.com
References: <20211006054705.21885-1-peter.wang@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <0600b929-98cf-034d-a49e-c7d13e887422@acm.org>
Date:   Thu, 7 Oct 2021 14:33:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211006054705.21885-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/5/21 10:47 PM, peter.wang@mediatek.com wrote:
> Mediatek UFS design need disable auto-hibern8 before suspend.
> This patch introduce an solution to do pre suspned before SSU
> (sleep) command.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
