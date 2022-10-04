Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ABBEC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiJDWb3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiJDWb2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:31:28 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659506DAE5
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:31:27 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id f23so13867581plr.6
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:31:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ezl6cjlsnmhVvDc7MmQRALIQEUOLcYu9LEFNVGO11SY=;
        b=F6eO77QYEgVzh6m9ELAHEX61b/pM42PaaxZDewjNqusbhgpO67a8t+CkdCi8yr9kjJ
         8299dlMTIZgnV/fhDUHj386Rdnsng3Ia4yZRJ8MxvRZULnThXZC28PZYBzbeUFHmzzt2
         6Q9ScnAaOiNjprQLHrpwa82gkvXp2lYCXCpYh+Dd6CyGLuVV5XlwNX/22LPi/ZBsuiHe
         5nOUW9tE2dLOCh1ncRALIanmCPCgqQPsXOfUJZbAy7r2kvvHQIq0/Nmv7PaMsG60xPsY
         AsVfXbrqg3o3Wwl/6epnj+3F9X9UzCoktEQq5wqHRyR8PA/RbsJW4ymIGOSFzEAAUc76
         TmCg==
X-Gm-Message-State: ACrzQf1lbyLlEtbB7pkuwITsUGSNjosvf91k6j0vyaZ9vxL38iDpLT97
        my1kbwVZoI60tSjwxHHQdgva2GUA5g8=
X-Google-Smtp-Source: AMsMyM4MJ7wKTkThb22JDuT1EJVvrLtCl7FORDsQD3KpOFwKWCHT1JODjdypr843ltVp/7Vm+EdVXQ==
X-Received: by 2002:a17:903:22c2:b0:178:3c7c:18af with SMTP id y2-20020a17090322c200b001783c7c18afmr29040343plg.134.1664922686841;
        Tue, 04 Oct 2022 15:31:26 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id n63-20020a17090a2cc500b0020ad7678ba0sm66691pjd.3.2022.10.04.15.31.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:31:26 -0700 (PDT)
Message-ID: <32a7d0ab-1c97-0b95-def4-f0f549b3509f@acm.org>
Date:   Tue, 4 Oct 2022 15:31:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 05/35] scsi: libata: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-6-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-6-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert libata to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

