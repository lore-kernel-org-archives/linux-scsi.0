Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6D0CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B4896109E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 17:29:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhJLRbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 13:31:49 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:38744 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbhJLRbt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 13:31:49 -0400
Received: by mail-pj1-f54.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so2414775pjc.3
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 10:29:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=1i/trRgVnOtv4w9jBLWUEo9eFm0sWCh5R0z87haKdN8=;
        b=vh66UZaieG4hMM8VrBScHMlAWyTqwNhgC6WBx20gaoaIjGXIllbsikB4K67xV0nOEs
         vR6eUonB9+H+2l9Xpf9fGHcdS/MVQUl3tJHzeKh0hlutJacOi0ChyF0tkBBZ9BPqUupZ
         0WGIaFWPNDyhcQuap6BY4RZKrst6dXOCfoM54QKpTRN11yf0iBBi4+iKBly8VwOkOQ4U
         A6x3BAhHxisZIbVFssmiDmFXwEI/2DfFQcJcXrxV85eoDfAqWjeD4dc+ontI/UJ0vaPT
         p2aOmTURF3XzdV3Ti+R0iNGVGdc+CVMtSxC+Dt4LzyXO8wTzrkES8OUnImB2Kb8ErHhR
         VQmw==
X-Gm-Message-State: AOAM533FWcPo4tN33vTUbmT+FN4C0ig+UNwQhJ+/zdDKw0XPY/bh8Rm9
        SnVGzHy37nkz7QaFwVCNay8=
X-Google-Smtp-Source: ABdhPJz/cMn0CHGt3pWsoxPfzkZTBzSl+epfClUt6SWEGOvJR80paU410GLlBzWFFxswKdY43eIQhA==
X-Received: by 2002:a17:90a:1f4a:: with SMTP id y10mr7356571pjy.225.1634059786708;
        Tue, 12 Oct 2021 10:29:46 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id l18sm12133753pfu.202.2021.10.12.10.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 10:29:45 -0700 (PDT)
To:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Meeting about the UFS driver
Message-ID: <4942b187-f6ab-e93f-604b-df635043c2bb@acm.org>
Date:   Tue, 12 Oct 2021 10:29:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

A meeting will be held later this month to talk about the technical 
aspects of the UFS driver and also about how to evolve the UFS driver 
further. Since using email to coordinate a date, time and agenda is 
inconvenient, please use the following document to reach agreement about 
the time of the meeting and also about the agenda:

https://docs.google.com/document/d/1pYONI__pbNcVVQqPA7iSbeQRyf0IQOuZlYR7Gnrikco/

We will try to take notes and share these notes.

Thanks,

Bart.
