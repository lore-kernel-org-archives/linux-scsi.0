Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 345D6CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:47:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E7B220848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbfKDRrg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:47:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:39102 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfKDRrg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:47:36 -0500
Received: by mail-pf1-f196.google.com with SMTP id x28so9549935pfo.6
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:47:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JEu60Dpgn9F3tedGRfIQpkc9IKW/pK8p3P2LDj4vUi0=;
        b=QM5if3Fi90u77EdutGcOwafg/zUTHrgNOX3w86u4qDBIuF0GSsg4qJusLhfiu4Zxd7
         CSW72Je14TnwceTreYKfc7blll1pjashfieHPj/Tpv0sKm2HIjBMAjr6b6yxjnO46DKO
         CSIHg7dZN/7EhzC1WYMO4Jf8o9F3UUv/YjBo9iqf9Kbfa89uha+8tcwn8hJoqMSWEQKM
         On1jHh7hsul0cuPBO9M2YjptEyNxYPLeTYZxb+sLQkA35Q5n+3sFP1jR5fg0DAaLGMx/
         d7qSc5UkC2wT4LpsgzH8CMCTvcl3M6B2NYR/0KRm61AhihXq77MjVLJuZ6kX4E7H/t8X
         2M5Q==
X-Gm-Message-State: APjAAAUhQv8feKRujlmtRdXUdA6lYtKSf/tZFJmfH6UxqrJzFxq9lx8g
        9gSC02njPdtc55Vv8Hk0j0470Xc2
X-Google-Smtp-Source: APXvYqyqzoG8+2vyoMaKxytFsY3+yIhkttsyD4m7esAn2d2BjvKMCWbljY6qwZPfLNpvgOf8nFp+AQ==
X-Received: by 2002:a63:fe15:: with SMTP id p21mr30558512pgh.26.1572889655591;
        Mon, 04 Nov 2019 09:47:35 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id g24sm17912600pfi.81.2019.11.04.09.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:47:34 -0800 (PST)
Subject: Re: [PATCH 25/52] scsi: introduce scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-26-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <36ff92a7-fc28-aa68-e348-099c6c6de712@acm.org>
Date:   Mon, 4 Nov 2019 09:47:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-26-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Introduce scsi_build_sense() as a wrapper around
> scsi_build_sense_buffer() to format the buffer and set
> the correct SCSI status.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

