Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5130BC00145
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 20:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbiLLU6P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 15:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiLLU6O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 15:58:14 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B448B164BE
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 12:58:12 -0800 (PST)
Received: by mail-pg1-f181.google.com with SMTP id 82so9097436pgc.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 12:58:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmZjQd3jXq/k4FzPZTHcOhOs0eR2oZOnB2rryRYcq4g=;
        b=YCaB/u7po6ARG3pCl1LdIze6UHg+f8azUaeYt34Jo0gaDmscWTDSdBoyneFlLScl9c
         xkndbq5DAnCLROElr3niX6FKFCCu+v5dYaf9qJJO4MrqZ/KVLOdb0jAx5Gcdnh/FHOo+
         NTegoUtAFik3KCeHEFVxWpWnBWwluw4NEbAmGDBbHf+SSEmKLzvklB0dhTlRfglmyXgp
         PJ/rffXO8nzL4mxyeUWIzhln6OE4IM05sUXgJzmPcGwsQB/7qTmFv/aPVyPEy/PFWimb
         S3pCADfUDuFkhw/f6dMEL8udIqv7CJE1pMqJkpuprWxN02oKudgRVLhvOQaX56Y9rV4J
         wYhg==
X-Gm-Message-State: ANoB5pkVpljL4NyfDJLyX+pQv1d1WXXKveFN98aDocAJaIm0q4N+QwTw
        cAfvX0S2P4a6IZQsB7yvj0v6rzrIfnk=
X-Google-Smtp-Source: AA0mqf760ZSMsS+qK5P3wQrmr0nUsLfWhkshSFFrGVgjmcY9u8KLvnIW40nMyaswgHsiBx4aQ+pjzQ==
X-Received: by 2002:a05:6a00:1a53:b0:56c:a62f:b9da with SMTP id h19-20020a056a001a5300b0056ca62fb9damr21202109pfv.27.1670878691995;
        Mon, 12 Dec 2022 12:58:11 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id f136-20020a62388e000000b00574679561b4sm6203929pfa.134.2022.12.12.12.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 12:58:11 -0800 (PST)
Message-ID: <32aa9b88-5b92-f089-d449-4a0aa770b2d3@acm.org>
Date:   Mon, 12 Dec 2022 10:58:08 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 03/15] hwmon: drivetemp: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-4-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-4-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert drivetemp to
> scsi_execute_cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
