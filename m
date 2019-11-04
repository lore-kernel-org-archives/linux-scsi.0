Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AC9ACA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57E1B20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729497AbfKDRmr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:42:47 -0500
Received: from mail-pl1-f179.google.com ([209.85.214.179]:35773 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729361AbfKDRmq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:42:46 -0500
Received: by mail-pl1-f179.google.com with SMTP id x6so7892793pln.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:42:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vtKBJR/w/8DRiiRKeraKsNYkua+xOULvnMWP+BGmMlc=;
        b=pECHtmWxAi7RsJv3q6KHLX5+rQGoelEA/Y6RAQe55tHJC6CxsNl3SY4uUMubAlrpTP
         xXDBzMpoXRAo+gqJdziJcuMMlw4mE6R5B3DOIruFb3KoBwepoZn4yua4xZzVegxpjJ2K
         8utEPfwhU45LxH+PzgoYW0yzHJ33YKu5x0/RBICAq6z9vy0+rQbFx7OnS6R3tCPkolGI
         hKp++R/M9/hPdudmnodfweiSak01EPR2BHgJHyxTyofqONJVH0unDmNwvCm25pTY3ecl
         v8dJyByd4XHucfRAzL00x/MfuaV9Z/wNkfZrPTMc1EeybwAkaVUhRHhMXUKh5v61ZPjm
         ldbA==
X-Gm-Message-State: APjAAAVvmgYyX+DXxKN3ngOwWP8kXOUBy6SZJtKYiYu8SMnMtN9Rfuvp
        t6+8j/BtfsFZUpemGKrIh0KgUCxS
X-Google-Smtp-Source: APXvYqzrKsELRsJ843BIIBzKM3LCoo4XIRQAIPFeog3r7/VSQSS03TXWzcrDY2BDThTY5lXEzax7+Q==
X-Received: by 2002:a17:902:b485:: with SMTP id y5mr28262892plr.292.1572889365764;
        Mon, 04 Nov 2019 09:42:45 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 27sm16975061pgx.23.2019.11.04.09.42.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:42:45 -0800 (PST)
Subject: Re: [PATCH 16/52] dc395: drop private SAM status code definitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-17-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <14638650-68f9-bde4-3f7e-84070b210b0c@acm.org>
Date:   Mon, 4 Nov 2019 09:42:44 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-17-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> We don't need to duplicate definitions from the common include
> files. 
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
