Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A41C3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:37:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EFF613AE
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhDTPhn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 11:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhDTPhk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 11:37:40 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F40C06174A
        for <linux-scsi@vger.kernel.org>; Tue, 20 Apr 2021 08:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=J/6aSRjHwBEmMywzlrZVSOhpAMviMii4sFz2+AcLaEw=; b=uTolYr5VMtcG1/yHnWqyVoMfVB
        5yxhGwmxucy5GSSy6z6dScsAgAHfS14XOXEhv4bXYrpdsgXKDQz+0eXB+skaNt7Bfb9eSknM6lZN2
        iRQRND6e5Ebzoe+ptXOausQ/jFMVaINWHeM5H8u+3pIl0iGepIqBlJ/akkMHaAZfBt/wjOaWZLQAz
        MwB3xwmAb6n1DE007r0qAx62AUOKmvVjrQkJ6KMfGvMR+HfJEhEVKRosfMk7wWllTcwWh5VCZ/JYS
        tQFuNqMRF+Ca9LaCVw7J4gvAdGw3Wn2Im9GQrQ6z7FxxeT4zXEJGpN0mKTS43Pj/fyLJJ/I7RDWNH
        K+LYLOKQ==;
Received: from [2601:1c0:6280:3f0::df68]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lYsPq-00FKaG-7q; Tue, 20 Apr 2021 15:36:11 +0000
Subject: Re: [RFC] qla2xxx: Add dev_loss_tmo kernel module options
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        linux-nvme@lists.infradead.org, Hannes Reinecke <hare@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Arun Easi <aeasi@marvell.com>
References: <20210419100014.47144-1-dwagner@suse.de>
 <cb00b188-31bf-d943-8f82-31c8c966c728@infradead.org>
 <20210420123723.bregf4debvyincpo@beryllium.lan>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <7d7e3cdb-3603-0b3e-9f46-46cf4310520c@infradead.org>
Date:   Tue, 20 Apr 2021 08:35:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210420123723.bregf4debvyincpo@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/21 5:37 AM, Daniel Wagner wrote:
> Hi Randy,
> 
> On Mon, Apr 19, 2021 at 09:19:13AM -0700, Randy Dunlap wrote:
>>> +int ql2xdev_loss_tmo = 60;
>>> +module_param(ql2xdev_loss_tmo, int, 0444);
>>> +MODULE_PARM_DESC(ql2xdev_loss_tmo,
>>> +		"Time to wait for device to recover before reporting\n"
>>> +		"an error. Default is 60 seconds\n");
>>
>> No need for the \n in the quoted string. Just change it to a space.
> 
> I just followed the current style in this file. I guess this style
> question is up to the maintainers to decide what they want.

I see what you are saying, but the file has no consistency
of style in that regard. :)

oh well.
-- 
~Randy

