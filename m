Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EBCCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:50:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8526820848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:50:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbfKDRui (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:50:38 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41753 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729481AbfKDRui (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:50:38 -0500
Received: by mail-pl1-f194.google.com with SMTP id d29so1559190plj.8
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:50:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=sO6GRp4EDHpK6CC6d62TCoqYTM9pcT5ntpurvliIvyb2JNGnJvZLSl1fgzZXVcG4Hp
         AhCWBs179zNv1cvMEEF/gHvGoPj0fyYPr0KTl8/BjmUz83JmPnQUWFTBnEB3gIaBvalb
         mdY0VY0jk3oRmWPz2UUbyyMgpAKPuRHAGrY7nhw1bVRsNPNFszKvhUi90qLuUj9Ci3YP
         6XkzZwMhCHzfUvEIwAFpNiOauAHf1tilY61o8IcUApA2LhOyNaBZ1rW891micGFD7yUf
         N4QpoKUtfbfRwUJEpCoTwJFO0StyvaNtlAmn5UHZVrILwbjcorG6V0iqXA43p6UN4bjn
         PBWg==
X-Gm-Message-State: APjAAAUk9cLwH6kiKPO6w4Z265QJTFkwIORrhzaVJI0YI5QDfzPyNWar
        NcNE7nzMaRZ2d5ytLv0799O+oC4g
X-Google-Smtp-Source: APXvYqwDQkP8BbV/bfnc6t8wexAcXctua4v0Tn6rSE3A8poi9+R5N1qFE9PeOdMu7NAxlPQXHGiZXQ==
X-Received: by 2002:a17:902:b485:: with SMTP id y5mr28294633plr.292.1572889836912;
        Mon, 04 Nov 2019 09:50:36 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id v23sm6646929pff.5.2019.11.04.09.50.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:50:36 -0800 (PST)
Subject: Re: [PATCH 34/52] myrs: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-35-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <444d5597-0fa4-e365-452a-7e0323b71dc7@acm.org>
Date:   Mon, 4 Nov 2019 09:50:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-35-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use scsi_build_sense() to format the sense code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

