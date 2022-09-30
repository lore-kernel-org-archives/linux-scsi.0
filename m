Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F11A6C433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Sep 2022 00:05:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbiI3AFO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 20:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiI3AFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 20:05:11 -0400
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 093C66BCF8
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:05:07 -0700 (PDT)
Received: by mail-pl1-f169.google.com with SMTP id w20so2557672ply.12
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 17:05:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=paImz57IKMVzOjdjCesbgcnzMbf4SIYKuCxQP+iy4NA=;
        b=XsPTIdgZBQXv7oxOVtiEpLJsuEWaOl1TLhGvsH0Y1+dLTeSHlLFPJ7v5UaO0dVfkea
         c9/CVEBhI8FFofJyYM+v9ao8hwCU/V2zpwXmIwaa801vSumPMHfO2LmwexrbsxMi6tmu
         SHyvgCc/8fPtuO7xT33Rxk/qb36ofg6DmTZEIATtmjg5wa5lmpSk1XEZzCAQ/qqS8es7
         hGomMsFiKonvhA8rCNyf8CvNy9emMoyZT+l7tWOmkboSZWYa49TFUKufNhtl8tbTvyG3
         PXqQn6lhtb545Qn2dVgig9Rqk3Y0qZTRd6h0TL1A57bEHbVK0g2L+AG9TZBonFC2qsm7
         ayjA==
X-Gm-Message-State: ACrzQf1MIlTX8jpzRlF/Wbg8KHSfu9gYHMsfRYLXsc5mloKNHlsL4dOy
        SlQe4aSKxiiRT8PyRq/8KqU=
X-Google-Smtp-Source: AMsMyM40VWRiojbaWbXJ4hzMOWNshLPMHZ4hGWIG4G21Kuw+bTVqfJwDDbUGE9V5MB2Mf7cR5owW/g==
X-Received: by 2002:a17:902:b705:b0:17a:dd:4c3e with SMTP id d5-20020a170902b70500b0017a00dd4c3emr5999581pls.14.1664496306274;
        Thu, 29 Sep 2022 17:05:06 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:56f2:482f:20c2:1d35? ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id e12-20020a170902784c00b00178b717a143sm474139pln.126.2022.09.29.17.05.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 17:05:05 -0700 (PDT)
Message-ID: <414a3d36-7c5e-fc17-f4f5-9e58a5d6a680@acm.org>
Date:   Thu, 29 Sep 2022 17:05:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v2 01/35] scsi: Add helper to prep sense during error
 handling
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220929025407.119804-1-michael.christie@oracle.com>
 <20220929025407.119804-2-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220929025407.119804-2-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/28/22 19:53, Mike Christie wrote:
> This breaks out the sense prep so it can be used in helper that will be
> added in this patchset for passthrough commands.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
