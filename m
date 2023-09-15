Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE9BCD37AC
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Sep 2023 20:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjIOUm7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Sep 2023 16:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237472AbjIOUm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2023 16:42:26 -0400
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DAE1AC
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:42:21 -0700 (PDT)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1c3bd829b86so21956435ad.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2023 13:42:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694810541; x=1695415341;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Amvc8f6xd0EFnP74iD8yF2GZMCvHbCa9x4BRoXblaMQ=;
        b=elzaSYGegesXhwpWMsyw7gEgfYYpGiVgglp/sKG0X+XeS0esTGrL3m+dFM0WXXKAeR
         T5upRkAXEcQw9mfJHR9iw/IVDOM7w1yJsz7T9A2kJOV0vPW2yzJNS79y6ZjMPZ82P5Bf
         sPHChKKHzQzltEnsJHHAY2gqSo7wQDLGtDMcX7IFGNl7dEM4fYMVjFQq2Grjhc4Vw96t
         aMB2RWMKXc+QkLI5RL6HrnIQwSQVLgFxKjjsdCggmLK7CbpmFGTqHWc+y6mL4BEpg6Qa
         Ab5vBv32zXG06It6jJe7Bt3zyCIMRzkcGV1TJMVY7E7SbxMUdvobjbFk3wtLfm7EBXjQ
         gEJA==
X-Gm-Message-State: AOJu0YzVoDjeMCAj8KYCvVNy4VtzXfwiDR92TU7wW/UD6OZqYLqA9ww7
        BxwjyT9ggmVQBRPOkUh9hBGXrVDuBG0=
X-Google-Smtp-Source: AGHT+IEe8PtVh0zZtvGSHJETXE/cr1OWjvTYBwfwnlNmX7CUNFPkBtYwBy5Ga3ZbX+vvoKKLj4EwfA==
X-Received: by 2002:a17:902:c24d:b0:1bd:edac:af44 with SMTP id 13-20020a170902c24d00b001bdedacaf44mr2578699plg.51.1694810540633;
        Fri, 15 Sep 2023 13:42:20 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id p8-20020a170902e74800b001ba066c589dsm3891744plf.137.2023.09.15.13.42.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Sep 2023 13:42:19 -0700 (PDT)
Message-ID: <41689a20-af9d-420f-af4f-72e299a765b7@acm.org>
Date:   Fri, 15 Sep 2023 13:42:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug 217914] New: scsi_eh_1 process high cpu after upgrading to
 6.5
To:     bugzilla-daemon@kernel.org, linux-scsi@vger.kernel.org,
        Damien Le Moal <dlemoal@kernel.org>
References: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bug-217914-11613@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/15/23 12:33, bugzilla-daemon@kernel.org wrote:
> The users loqs and leonshaw helped to narrow it down to this commit:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=624885209f31eb9985bf51abe204ecbffe2fdeea

Damien, can you please take a look?

Thanks,

Bart.

