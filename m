Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAB1C636D6
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Feb 2023 15:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234724AbjBWPf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Feb 2023 10:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbjBWPf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2023 10:35:28 -0500
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4947957D3E;
        Thu, 23 Feb 2023 07:35:27 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id r7so10835736wrz.6;
        Thu, 23 Feb 2023 07:35:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pQe/WnpSMAW2mDbkmE0tjSb/o7wgQczEKKxf9Jtlnnc=;
        b=xnsIQWehfu2rxxwqtqyhXc9N51RAvVn81fKh7fqu9QQVCLuQQqzFEWOJPGWAZpcwhz
         RGoYkHXRAJAnhuaPXRL4aejdaXK+MqP75K6tJT7vtJrfEVPrBFHdmuAOZzU+4rVunVvs
         XdD9xK3YAGVbwB0WDyX0gRhJVnAUywqxTLleafhA5bILXI9egsDEpJcvYn43JLFW50f8
         mJywcWzcuh2ki6uRh50ywuGCumVJ65RSYtMXnByThUKMpdvxCUIvI9KbBOsSbSuiGRhr
         KdL6Gdp7tNH86fXMTUsO+0TcfTcoY9PY8GpUlvHpUS5YMlGZxQazpYBoe2yIgWq+yTlj
         TP7g==
X-Gm-Message-State: AO0yUKVDngE3Ga1oJnVDi57CpYYUR/TS/YIQ6AXZp+piTekvL1dJ71OX
        EwybbxLF52UCu3tV19uijNJ0AnGsyWo=
X-Google-Smtp-Source: AK7set/KFJVUpx9U1606sZfdF40dDGZrrfSPJV+F9VjEhmT/9eemxiLat4EB5PwUkYTjkefYdPluRQ==
X-Received: by 2002:a5d:60c7:0:b0:2bf:de9c:4595 with SMTP id x7-20020a5d60c7000000b002bfde9c4595mr9390894wrt.5.1677166525786;
        Thu, 23 Feb 2023 07:35:25 -0800 (PST)
Received: from [10.100.102.14] (85-250-17-149.bb.netvision.net.il. [85.250.17.149])
        by smtp.gmail.com with ESMTPSA id v15-20020a5d4a4f000000b002c7107ce17fsm2078608wrs.3.2023.02.23.07.35.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 07:35:25 -0800 (PST)
Message-ID: <561afa67-04d0-c675-6bbb-048313da152b@grimberg.me>
Date:   Thu, 23 Feb 2023 17:35:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [LSF/MM/BPF BOF] Userspace command abouts
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     dgilbert@interlog.com, Hannes Reinecke <hare@suse.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        lsf-pc@lists.linuxfoundation.org
References: <3d3369f1-7ebe-b3b8-804c-ff2b97ec679d@suse.de>
 <Y+5cjPBE6h/IW9VH@kbusch-mbp>
 <ad837a26-948a-c690-cd9e-4dfffb5f990d@grimberg.me>
 <57d8dff9-2fdb-8198-6cdc-7265797a704a@interlog.com>
 <23526cf9-d912-59a7-4742-6003d6ccfd45@grimberg.me>
 <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <Y/Yscr82hqdKl1Hw@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>>>> I did not understand what is the relationship between aborts and CDL.
>>>> Sounds to me that this would tie in to something like Time Limited Error
>>>> Recovery (TLER) and LR bit set based on ioprio?
>>>>
>>>> I am unclear where do aborts come into play here.
>>>
>>> CDL: Command Duration Limits
>>>
>>> One use case is reading from storage for audio visual output.
>>> An application only wants to wait so long (e.g. one or two frames
>>> on the video output) before it wants to forget about the current
>>> read (i.e. "abort" it) and move onto the next read. An alert viewer
>>> might notice a momentary freeze frame.
>>>
>>> The SCSI CDL mechanism uses the DL0, DL1 and DL2 bits in the READ(16,32)
>>> commands. CDL also depends on the CDLP and RWCDLP fields in the
>>> REPORT SUPPORTED OPERATION CODES command and one of the CDL
>>> mode pages. So there may be some additional "wiring" needed in the
>>> SCSI subsystem.
>>
>> I still don't understand where issuing aborts from userspace come into
>> play here...
> 
> The only connection is that aborts are obsolete and unnecessary if
> you have a working CDL implementation.

OK, that makes sense. Indeed I *think* that nvme can support CDL and if
this is useful for userspace then this is an interesting path to take.
