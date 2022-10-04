Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A30FC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:45:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiJDWpT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJDWpS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:45:18 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12DA2A253
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:45:16 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id 67so82186pfz.12
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:45:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=1czxOPGxXve63dFTcCHgzjntgLvWNvykHheayQKAeR8L8yAu4PfjsHSiiPgd3ubnJY
         EyoG9NrHg2Da/GpcGgmsuxhxiOTCDn7//d5rYHdwwvL9MP72KwT3v9T39puFvNgwgmO2
         Hh1wKFGlhUCpEGwUAzpkjMQ7ZseHsGlwpwggY8KLU1QhEF6COYrYk+nzlhHNUqDsBBOi
         f7KI/iLnIpV7SwSh1kmyBixsWDoXVTcmmnSQz7gj4qXWeSIzeeBMko4V0VEUq/G9gdg8
         1zptIFBEvzLz8zGUqEm+oDT7giyxa2+9f8yWr6CIHEhLOLhVuazuUmUYjXCyvC9q6XK+
         n/OA==
X-Gm-Message-State: ACrzQf2f6iUITA4b5LzXi9HJk/lvaZu1nm59zpOP7wrjV1EGPqTwwtA9
        JadGr7LCW7L62k1hwPcUO3I=
X-Google-Smtp-Source: AMsMyM78EZpc18TDWFptslwxBkz0GMK6G6setKrjHiTHMBB5gPn3PmQuzW2X7nZIlOzykW4AlweCxQ==
X-Received: by 2002:aa7:8b13:0:b0:55f:69de:d17c with SMTP id f19-20020aa78b13000000b0055f69ded17cmr18770545pfd.20.1664923516289;
        Tue, 04 Oct 2022 15:45:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902e84700b0017829f986a5sm9567423plg.133.2022.10.04.15.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:45:15 -0700 (PDT)
Message-ID: <ce68b7c0-7b50-616a-f843-e3a27b29e000@acm.org>
Date:   Tue, 4 Oct 2022 15:45:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 13/35] scsi: ses: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-14-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
