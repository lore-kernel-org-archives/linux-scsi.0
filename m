Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB6FC433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 17:11:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A70123133
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 17:11:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgLVRKo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 12:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbgLVRKn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 12:10:43 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4E7C0613D3;
        Tue, 22 Dec 2020 09:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ik8+7drT2hf8fGhGbNu/E/uz+NLQQnAX3uaoN3mqMCM=; b=CG15D5+zJNT5EHh3IEnfMvfnwg
        wzhOHxO4uczqFycunh9BLLQ3yhcJln2rOKai0Vs11gZIyJH3YZ76t3pwZFhVhNHyFCDvkCdcdcoHi
        WStvQO7rbKgFPkxItDXL5jN96yu8oKxDA7y+yKgGCu18l1V5wY/hyh9trpToCzTrOSlD3PK+VdBAN
        LcDLQFZMWVGAvzOnPEGm9V1If5QtAYZRnSm26gG3YBtkxu7BnFn60XkjTbRwy3qe/Lb6JIWCauEek
        sfJEAP9QLxNwHJPFzfZtpTH2tND7QtLyaekekmyq4+7AUYtzDQohhWzgXrpm1OHcurD/rdKuN+15F
        3hR6/KSA==;
Received: from [2601:1c0:6280:3f0::64ea]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1krlAd-0008BG-Cv; Tue, 22 Dec 2020 17:10:00 +0000
Subject: Re: [PATCH v6 00/16] blkcg:Support to track FC storage blk io traffic
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, hare@suse.de
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        pbonzini@redhat.com
References: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <2780d561-c1cd-c82d-57e3-7b79db1071aa@infradead.org>
Date:   Tue, 22 Dec 2020 09:09:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1608595918-21954-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/21/20 4:11 PM, Muneendra wrote:
> This Patch added a unique application identifier i.e
> app_id  knob to  blkcg which allows identification of traffic
> sources at an individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.
> 

Hi,
Can you get rid of that legalese footer message?


thanks.
-- 
~Randy

