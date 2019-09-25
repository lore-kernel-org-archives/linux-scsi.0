Return-Path: <SRS0=jwuq=XU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 905F3C432C2
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 15:45:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 601AD21D79
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Sep 2019 15:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732856AbfIYPp0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Sep 2019 11:45:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36143 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732686AbfIYPpZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Sep 2019 11:45:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id t14so1964pgs.3;
        Wed, 25 Sep 2019 08:45:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DPN5lOgMk4ewWDxp79xsQgrrgk+HRYTm042wneV3BNw=;
        b=ZNhjTF1warj6FxoYw8HbBIqcs3/nvRe4FMfAB1pUTpEvN/yjVwtpVeV0yMytwHQkQU
         ffKFPAgvflpwVkqnNWHvZiuJaxP+qw0Kk/80T4+q2ny68k1MEns5bjNkV/OwdVCmAtJa
         Zf3ekP9+l/Qs/EsrnqmPSHOcY+xa2bDOjtGzzeF7pXhCQgHAOTIq7Hi0EM2bCoqWsPXz
         75l+pk0m5D0K4HizZNp75kfllQFOlq/ScX9OWHzf5tKQw4X8dsCEaa579QwvzLA5Iw4Z
         vLG+e5xZSBJ3CgeEjYYxXWMJopHiSANBwCS7f1oWZ1uaCBT3/pyPUTfXoWED/bXTdJvF
         SRNA==
X-Gm-Message-State: APjAAAV1o5GFM42Roi06qOznB1PEGKKmFeEhdkNvhLl+Bffat1rhRS+s
        X0WvdM0lHOCqwE7JX3JIXFfDjtMF
X-Google-Smtp-Source: APXvYqy3HFChRZ9z6mRtGJP5l/eH/2SU+zJ1FrSDGczZcq4nukRa5t4kCk+EClxO4NiEPLj5askaOA==
X-Received: by 2002:a63:1749:: with SMTP id 9mr9114175pgx.387.1569426325049;
        Wed, 25 Sep 2019 08:45:25 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j128sm9996393pfg.51.2019.09.25.08.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Sep 2019 08:45:24 -0700 (PDT)
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
To:     "Milan P. Gandhi" <mgandhi@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20190923060122.GA9603@machine1>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c28778e6-62a1-b510-f6aa-fd67b54ca54c@acm.org>
Date:   Wed, 25 Sep 2019 08:45:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923060122.GA9603@machine1>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/22/19 11:01 PM, Milan P. Gandhi wrote:
> +	off += scnprintf(logbuf + off, logbuf_len - off,
> +			 "cmd-age=%lus", cmd_age);

Have you considered to change cmd-age into cmd_age? I'm afraid otherwise 
someone might interpret the hyphen as a subtraction sign...

Thanks,

Bart.
