Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3684C4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:01:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiLLVBp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:01:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233548AbiLLVBL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:01:11 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D6719C1E
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:00:22 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id fy4so1168253pjb.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:00:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q5rRQQOD8ANataEqVDj4XPT4QyrePJD1b7SxLaL6L6s=;
        b=eKjzCrHKDeHWwq9dsmle6OkzH/tpkwoR8EW2JmC5xRdr0G+IdDTNvP8T7g6S4e7bz2
         5wEsoBda2wziz+fnDLB9jBQ37VCcr6ornZ+he5Vgs3fTPoMEuCsRfrX1ay8H/ZMu/YfN
         XV+vhT/5DiaGqf/Am0MGEBdqLhm3suA/zec2h++8OluFaXdTXre3ezEJBF3lTr14p/9/
         6MLS1wK86YP7fDIO96x+Y7uRPSa94gy/Xkfs2URBlXEQz32hG+GJhrWWjxpuer+AUfVr
         GARyXbhy9DwpEnjUMLrE87Oh2dc8Pc/HYn9EpbrGJg2nIakOoSAgW7Z4OfEe7UY+/5Pc
         Juzw==
X-Gm-Message-State: ANoB5pnafTTyyFjThSjOKJlKb41gpp4K+vYBL5csA4HxNhrmQ3/R5HvV
        PXvtMULfTBxzQRYZd9g//bA=
X-Google-Smtp-Source: AA0mqf4R5JdjmuTeHEw9s/FYi9+Ud4KFZ2UFIu7I9wODKiQOt8rUEl7MIETJb6Cl9jtc9KzYo3d5Cw==
X-Received: by 2002:a05:6a20:8922:b0:ac:a26a:dae7 with SMTP id i34-20020a056a20892200b000aca26adae7mr18567226pzg.36.1670878821911;
        Mon, 12 Dec 2022 13:00:21 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id e26-20020a63501a000000b00477602ff6a8sm5497637pgb.94.2022.12.12.13.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:00:21 -0800 (PST)
Message-ID: <860fc507-6da8-263a-89be-975bef26d974@acm.org>
Date:   Mon, 12 Dec 2022 11:00:19 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 05/15] scsi: scsi_dh: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-6-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute is going to be removed. Convert the scsi_dh users to
> scsi_execute_args

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
