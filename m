Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42B47C47E49
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FD9021655
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728971AbfKDRiv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:38:51 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40837 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbfKDRiv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:38:51 -0500
Received: by mail-pf1-f194.google.com with SMTP id r4so12725738pfl.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:38:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=J/oPQd8+HDpOUKb/Mj1JK1BBtilYEtI28ANGeTw6NVxArSoeUvHN5qXY4UiYplyyku
         yT92n8ktLLyWgZpr3qjDDJ1hTOWLa4X+PsL/FaoOlTNCwtsHQ4BMSYBiujccl+cCaVH0
         TOk9cFFLwEPQKZiP83ttPSKzSq91aWxHUB7drsTPkZrtLS6DiiO6njPenJMlgOceozK9
         QuSKk8S6sw/wiEWhUvJ2r6LiyH726iGLjyMNQL25P8kZ8AiIinA1ySWX6BeCEkYG3UMz
         m4/WKYBHBR4eausKK1FAxTmwprZ28dHD6Np0k+hsl777hL0KI5ghLtoVVEmBEHJjelaw
         FlDQ==
X-Gm-Message-State: APjAAAUj8CwhcSpxSGQfPEYYPrcIlH/9/OACpM1yY6YpomCMWw87vO8O
        qNW66LpuEAFuRrHlLs5xQi1itRFO
X-Google-Smtp-Source: APXvYqwhvyzNUPUxy8SIaIvsY5JCrcCEpSHG50fhIWBifQeGOxHmviI6nI3LHTtcZc/zGPayJHDQNg==
X-Received: by 2002:a63:d0f:: with SMTP id c15mr31509374pgl.313.1572889130072;
        Mon, 04 Nov 2019 09:38:50 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j14sm17491359pje.17.2019.11.04.09.38.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:38:49 -0800 (PST)
Subject: Re: [PATCH 09/52] dc395x: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-10-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <46d80e5e-1a69-5a35-76c8-da9ac89c6717@acm.org>
Date:   Mon, 4 Nov 2019 09:38:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-10-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status codes and omit the explicit shift to convert
> from linux-specific ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
