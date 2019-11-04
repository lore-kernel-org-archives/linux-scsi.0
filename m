Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32686CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14B9B20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfKDRvZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:51:25 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45274 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRvZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:51:25 -0500
Received: by mail-pg1-f193.google.com with SMTP id w11so1471844pga.12
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:51:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=DW7iQygLjIueUauloGgfBxKYC3zk6WXS/srWPCisoNuAiLvOBM96opVIKKu1DOdASX
         pv1alIa0XDC5zkEg664OokjnMczyCvgHF133PSrLftS811IB5I+VEsPWN0PR0kjiZ+o8
         4A1Dd0aRFkCkGjHxHKWlgWDmIJS31NYA77VaCezbQGRLDdC4lAzxRKjqqZycEPQu1TfO
         bBmtrkVE3lUqfBxlESVTfuf5swn2Ke/xThOL0wn1UoWCJ+LA7CrQv/+HFbVVoeDhbtbU
         8LWqQ6D42K7oiqjU68CvtzHRfljqnQq88F4k7QCTrgY120bWUq4WtR/HygMRyO7umxLh
         gQhw==
X-Gm-Message-State: APjAAAXcCrjsPD8y6EVIKdlJZj9Xs+olugf2Fy4BnLTjk92YdCU7gm7R
        tXHO/Bwp+deiZmi1SKsLiqpFbUmt
X-Google-Smtp-Source: APXvYqxQqcz804KVcdr0qRgP4WrnmF5imk5PnHb5ZRCZ8aTwyMOiROiUUK2sKhIQZXG4+dcSp9XBaA==
X-Received: by 2002:a62:61c4:: with SMTP id v187mr32461107pfb.23.1572889884186;
        Mon, 04 Nov 2019 09:51:24 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id v14sm11359648pfm.51.2019.11.04.09.51.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:51:23 -0800 (PST)
Subject: Re: [PATCH 36/52] qla2xxx: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-37-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <670a5d98-2644-3ad5-959c-107443feda1e@acm.org>
Date:   Mon, 4 Nov 2019 09:51:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-37-hare@suse.de>
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

