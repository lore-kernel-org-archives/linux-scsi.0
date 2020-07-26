Return-Path: <SRS0=zfIH=BF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6099C433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 843FC20714
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jul 2020 15:10:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ultu3nd1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGZPKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jul 2020 11:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbgGZPKh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 26 Jul 2020 11:10:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89795C0619D2;
        Sun, 26 Jul 2020 08:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kcuMXgFNFtIkl0GDj0p20pjT96YpQLVHcMeUCcbH19o=; b=ultu3nd1Zhi8vL8FqmXKkj+BID
        BNIjw/hg0UdljRqFd7Rt8DJFCCNdkCL2ihNeIiatBgZyRIqxDR6Ba/cDaTgqG1bMdFY31yVUv6uil
        SdZoK9WXeKq9uleEJF7W/Acu6G4jvO2q3dj304dy28OndAm0VqiftzEVfBiOQEAamCdfAihZ4Xko0
        y7eWnsGb6A1EqyThHab2Qv2VtpG+i6dvEISnNqdeayq4QgK5HeozbiGbHKnXcbIQKX6l+tNF/0qDQ
        Aym2A8NtFTDoCKCd0/Z/gjFWYb7xaeUEU3/pu2dUNJ0vgXWvonCEyRcxlMWnVIJAhCYP674xLg9Xm
        j2LQEwfg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jziIN-0006JY-E5; Sun, 26 Jul 2020 15:10:35 +0000
Date:   Sun, 26 Jul 2020 16:10:35 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Tony Asleson <tasleson@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
Subject: Re: [v4 00/11] Add persistent durable identifier to storage log
 messages
Message-ID: <20200726151035.GC20628@infradead.org>
References: <20200724171706.1550403-1-tasleson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724171706.1550403-1-tasleson@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

FYI, I think these identifiers are absolutely horrible and have no
business in dmesg:

Nacked-by: Christoph Hellwig <hch@lst.de>
