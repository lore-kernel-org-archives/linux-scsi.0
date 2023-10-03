Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B9A0E748FA
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 17:35:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbjJCRfD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbjJCRfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 13:35:02 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B47AAB
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 10:34:59 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c62d61dc96so8822445ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 10:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696354499; x=1696959299;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XxLptbuHTyAEtt354i/XMkHohGtzg+mHdePuKldsVmY=;
        b=eOlLde6IPbtDGeaDBuGnUdv+iF2yLr8WF7zFFL+efdQAqpuPGqljVFgTTZL6j9Zj8a
         qiwPmtenqFNdX/A2NNN9O9+EoLFrOY2IePU5F7/fXeJP/5yPxhZ/orcifqdsQkG5li4q
         GQ1Tj3dhe/Omf0cWo7rUOOXgnnG7GdC9CcdTGRUB57P6ddG8BHBaMcUTNRCx8BvRnKqx
         arrNw6rM2B+Td+FjbbSMmV+eNhrT/5MJqZU/C0EOUUvkh33iVWgrDQz5w4wpj1FEFgTE
         hS+SrOxrbuKnuWtb4RQDCf+BLQjCWR2c6sb0+MJd5mAGzIuNRv4v+JiuMQThqnrLHkso
         x5Cg==
X-Gm-Message-State: AOJu0YzSGrtvTx0uV8kFAa9+UMvwXLRiBeIHvYwdGvpcRVOufHJ+Eq3U
        PeCdFfA/fkpHz/cBIlg5GcQ=
X-Google-Smtp-Source: AGHT+IEclbJpfOozejsnzQvkU6axR/xfCITG1wpUM+ihgSEgkKMfS15zvvLZRW48l5hio5x4n7ZgKQ==
X-Received: by 2002:a17:903:41d2:b0:1c7:71d2:a96a with SMTP id u18-20020a17090341d200b001c771d2a96amr367683ple.12.1696354498917;
        Tue, 03 Oct 2023 10:34:58 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:fc96:5ba7:a6f5:b187? ([2620:15c:211:201:fc96:5ba7:a6f5:b187])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902ea8200b001c62d63b817sm1856449plb.179.2023.10.03.10.34.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 10:34:58 -0700 (PDT)
Message-ID: <351269f7-ccca-443e-a3b0-3131eb7aada8@acm.org>
Date:   Tue, 3 Oct 2023 10:34:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] scsi: remove SUBMITTED_BY_SCSI_RESET_IOCTL
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-7-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231002155915.109359-7-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/23 08:59, Hannes Reinecke wrote:
> Unused now.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
