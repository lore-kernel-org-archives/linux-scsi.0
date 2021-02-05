Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2817C433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 19:38:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7817364FBB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 19:38:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233413AbhBERzp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 12:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233279AbhBEP3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 10:29:14 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E623C06174A;
        Fri,  5 Feb 2021 09:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=GRt5Yg72WXfbpOggwhk6UTUSYqZQvSAMTniZG+O1JGY=; b=J41vMNa2C2Ap3bSEH1ae/iwDV/
        vChERwoPU4qZIvz0k1d587vd45N/BpbqISFsGsERWOf3sErqJRct/ScWuoG7st7pzMTIhhTvquuOt
        SdO7JvnKK8bg21r3Kttq+gI30pe4UfCnraC+GgjG9g/jxKJLZarNFC2rESNWZam2o6Fhs8ShqgaDD
        lKccp6nrxpPnGFrwd6SgT7FUL72z7k8vZFMgKp8lDjuDooevld35gsdAUIVAonuNIr95p4114FXNQ
        JjvDo0TD85RB/I+Ypimf/D7pWq+Io2/eesqqNkZYaNqtGLC9+3j4d9NJufMfqZ5YHVIoowEsTo82A
        pM6+sFRQ==;
Received: from [2601:1c0:6280:3f0::aec2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l84dA-0002wu-RD; Fri, 05 Feb 2021 17:10:53 +0000
Subject: Re: [PATCH] drivers: scsi: File ipr.c gets few spelling fixes
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, brking@us.ibm.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210205091257.484726-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8608c3b4-8919-27d1-5ca9-d6dc0c587dbe@infradead.org>
Date:   Fri, 5 Feb 2021 09:10:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210205091257.484726-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/5/21 1:12 AM, Bhaskar Chowdhury wrote:
> 
> 
> s/Enablement/Entablement/

http://dict.org/bin/Dict?Form=Dict2&Database=*&Query=enablement

> s/specfied/specified/
> s/confgurations/configurations/

These other 2 are good changes.

> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
> ---
>  drivers/scsi/ipr.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 


-- 
~Randy

