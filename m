Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C4B9C77B76
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 19:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbjDQTOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 15:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjDQTOj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 15:14:39 -0400
Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D45210EF
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:13:53 -0700 (PDT)
Received: by mail-qv1-f49.google.com with SMTP id ok10so4857728qvb.11
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 12:13:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681758832; x=1684350832;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yBtJVDxHkjT7DQCSOQzNe2IthXptum9ChouKTqEU27w=;
        b=emtWxBtrbs/uNsixyJqtbmWh2fTe8d7Rk0bVP10sNulMT/MeU/WQdwhe5+MtQs91et
         vYwnVH1HzvwponTCHTwXpBc1xqIDcRA0PwobzLjrRFnbAZVg8T1buZ6vSRPVtbhLtj4+
         tphvYWM9ff108hRsuPfA6dEnegYz6nDZ17IAMCtvGpIhw2SvIKnwyu5x3ivscui+6q8H
         TnjYfDt2Mg0NInf46UaEfmfHCj2oncGSVzbgZrEFlJdpk7pEIdX+Xni3trL0h3ows+s7
         feElNH+0UKXkS1fQ06/r7YLAt4cljRGhHR+gbDZvyAqZfDkt5iZjTdWqBkONnejLOfMK
         8ouQ==
X-Gm-Message-State: AAQBX9e78kFUvF0iLBOzA5NtldpSBKUvPpPqo+7B36cRFGS49voupuCz
        V+QNYdoXTSzJIfvZYfhzR5lR
X-Google-Smtp-Source: AKy350YhhMmQjUtscx8DWNyjxCDA5LGW9pBXnmkkJTzahbIxgePxnjEG+PUB8GZIdmsQdXDjMB2WVw==
X-Received: by 2002:a05:6214:5084:b0:5ef:6101:3282 with SMTP id kk4-20020a056214508400b005ef61013282mr11320857qvb.0.1681758832583;
        Mon, 17 Apr 2023 12:13:52 -0700 (PDT)
Received: from localhost (pool-68-160-166-30.bstnma.fios.verizon.net. [68.160.166.30])
        by smtp.gmail.com with ESMTPSA id ed25-20020a05620a491900b0074856680834sm3332329qkb.132.2023.04.17.12.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:13:52 -0700 (PDT)
Date:   Mon, 17 Apr 2023 15:13:50 -0400
From:   Mike Snitzer <snitzer@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        kbusch@kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH v6 06/18] dm: Add support for block PR read
 keys/reservation
Message-ID: <ZD2abp1WQ0FqYXAT@redhat.com>
References: <20230407200551.12660-1-michael.christie@oracle.com>
 <20230407200551.12660-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407200551.12660-7-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 07 2023 at  4:05P -0400,
Mike Christie <michael.christie@oracle.com> wrote:

> This adds support in dm for the block PR read keys and read reservation
> callouts.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Acked-by: Mike Snitzer <snitzer@kernel.org>
