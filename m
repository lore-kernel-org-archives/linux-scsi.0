Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71EF0C07E9A
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A442613CB
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 15:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbhGNQBc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 12:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239755AbhGNQBc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 12:01:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C60EC06175F;
        Wed, 14 Jul 2021 08:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=Y1Jp3Hl9M92Nuxfx1/QPNtiZMokbdLy8C2g312gTFpE=; b=f5AG1TID/mHLpBe7BGBRWsZwoc
        rBZXS3oEmW1hXvNgLhkJ44E6W+F9iKxbG44bHKNBk8RQfuy9XCQB4izsMT1/gdiA1Fyd7c1FEqpKT
        kzNUydoO5S0GV8zbk/VVzrWcAkObNrw/1Lf8NopOmaTuGy87CzHaKmBUV0/CxKsAk4W7bvXovEK6S
        eBEku3kB6355htju8UAu/yKhYSSHJJ9RZGmxNmP2juAN5lLBj0WWIad0EpggGbebC1w2kk5RAccpP
        Uc0OiQsdDU6hKHg2GVvW8yYn5+tncNhbUnXzVqw2IMtLsGqL5gy4Z6ME32E13YsFj64+sytSwtCPT
        NbUhb+yw==;
Received: from [2601:1c0:6280:3f0::aefb]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m3hHT-00E1XK-3X; Wed, 14 Jul 2021 15:58:39 +0000
Subject: Re: Build regressions/improvements in v5.14-rc1
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc:     Marco Elver <elver@google.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        linux-um <linux-um@lists.infradead.org>,
        scsi <linux-scsi@vger.kernel.org>,
        kasan-dev <kasan-dev@googlegroups.com>,
        netdev <netdev@vger.kernel.org>
References: <20210714143239.2529044-1-geert@linux-m68k.org>
 <CAMuHMdWv8-6fBDLb8cFvvLxsb7RkEVkLNUBeCm-9yN9_iJkg-g@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b85a17e0-5e64-b48f-ceab-7cec19059780@infradead.org>
Date:   Wed, 14 Jul 2021 08:58:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAMuHMdWv8-6fBDLb8cFvvLxsb7RkEVkLNUBeCm-9yN9_iJkg-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/14/21 7:44 AM, Geert Uytterhoeven wrote:

> 
>   + /kisskb/src/drivers/scsi/arm/fas216.c: error: 'GOOD' undeclared
> (first use in this function):  => 2013:47

https://lore.kernel.org/linux-scsi/20210711033623.11267-1-bvanassche@acm.org/


-- 
~Randy

