Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAF19C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiJDWbu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:31:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiJDWbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:31:49 -0400
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964876DF8A
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:31:48 -0700 (PDT)
Received: by mail-pl1-f176.google.com with SMTP id x6so8592438pll.11
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:31:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=JYV5fAWLun6QlyRzfBA42a4bwf4LJZPZUocofP6jTYPr76vZcbwJfgzquLQeIqP4Pr
         fdTGQ1xKvUlNAZLaAPFm1Aub5TwwZrbLL8dIrsR6OyXpVobW284m4eAme3BycFBC2v5F
         Sg6beQN2I+YfoJAnD6GhOz7pXtUQQwCF0goYrFwclkK19Z3/9tI7yBRZmpmUSZExnqCR
         AzHhAZOSBG4WZ5PQGW0TQZmCjBY9Rhu7mg0/SxkgZBSpyIYrMJsTBVOUjjGgVozwCrOh
         YnmRu74I4e3h1FM3v1xtIJYC8utWihOj4fg11WnVsJOUPGTb/KttZfinN/OQTdxlD0HW
         yPWw==
X-Gm-Message-State: ACrzQf3MrTkkYIhmva1OaZ/xuAj862W6oDoK5N42YVY0OeGYnBPE6Q6V
        auZ0WiuIeu6v7x8hds5/pwo=
X-Google-Smtp-Source: AMsMyM6etGZav1UU00zgB+SQBAckrPjLvwjE8KICLaCiMefdLxRO+qt+9bxS5Hb4JrPSjyVP4NKZEQ==
X-Received: by 2002:a17:902:b68f:b0:178:627d:b38d with SMTP id c15-20020a170902b68f00b00178627db38dmr29208771pls.87.1664922708033;
        Tue, 04 Oct 2022 15:31:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090a4ec900b00200b2894648sm38778pjl.52.2022.10.04.15.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:31:47 -0700 (PDT)
Message-ID: <2e2fce7c-8e5e-258e-354b-c2c81976ae80@acm.org>
Date:   Tue, 4 Oct 2022 15:31:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 12/35] scsi: zbc: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-13-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-13-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

