Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DC79C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C914611CC
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:57:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhDZD6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:58:25 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:41576 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhDZD6Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:58:25 -0400
Received: by mail-il1-f170.google.com with SMTP id v13so5751148ilj.8
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:57:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qTI3p45sDNv5hgHsg9e8XxrSo6tk6kUTWA1AzIhH8vQ=;
        b=J1QLwrnwNAWKK2+XrwpTAX0x21eLxqDDBdBg5RQr3TlGRDV/+kVSIcgnEKQGk+YlB1
         /fIE1Ulr/woCh2xXQANOG/nkpHG4DznnLUEPxAeNSrOpjuuaaM/tPRGGtyuaPgFQjixr
         hsvQf0XwW9KPqfa5p9GcY++itpqE1lDGhESpGQ6w12EayOmGI3r1p4xEKZNanHzqfGcU
         tKBZhkQ0e4qM5c6VvjjxQrjoha5739aGRQX5B8b2qCM7GwfhNUur2nrjU3fZywx1HslC
         5nXtpFji5c2FO38pM7ho0Saoqrbv71jjG8xPLUHS/RgcV2leVn3LuFSUsO5buVPHTQDY
         nLEw==
X-Gm-Message-State: AOAM531aUEh6V2CStt6vb6HlU6/wlTLk/D0Oy+TAzGDm8MKDXr2EKb0W
        OoGdfoj4zwZ1H6ZFCZWeatuwV3jiwnw8yw==
X-Google-Smtp-Source: ABdhPJxClhB58qTGt7bbc4gpkC0mQuzViIb6NqVUiL+0Cu5rwse52WBriyThbgM7xTOh7umYxcBZKQ==
X-Received: by 2002:a63:db53:: with SMTP id x19mr8036756pgi.327.1619409021617;
        Sun, 25 Apr 2021 20:50:21 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id x13sm11911455pja.3.2021.04.25.20.50.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:50:21 -0700 (PDT)
Subject: Re: [PATCH 37/39] scsi: kill message byte
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-38-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cec38a4b-55bc-9859-816c-32819715c09b@acm.org>
Date:   Sun, 25 Apr 2021 20:50:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-38-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Remove last vestigies of SCSI status message bytes.
              ^^^^^^^^^ typo?
Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
