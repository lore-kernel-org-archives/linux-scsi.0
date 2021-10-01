Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A521C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 04:15:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E00D361A51
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 04:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235689AbhJAERj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 00:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbhJAERi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 00:17:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A06C06176A
        for <linux-scsi@vger.kernel.org>; Thu, 30 Sep 2021 21:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DOSlr2Xa0JW6tZCAAqM6E0CKKddJcYqVr49rDyetY3o=; b=InkwqMcTqOz7OuYHjPpRYPjzCD
        PiYXe1JD5z5/MadJP2FPANCA8ORkDpOfa592Ius4iZl8qaO/SWyegqZLP2ectjFJx+HYjfpK78T5R
        xVCjwJHFayaWW+ZDeG/A4n2kA7zr5FH468B63eZ7zmAjNcixiu6fmYnbNOXLpSC4dze6qkSDSgAmk
        iGIpLXkJMRMJG1rh7/KuX2zhaSftJJwC2SK8wyIH8xpJYNOTBfF3OKmkMJi8NWD74q1E1Qmq9u5VV
        tkqQOiZ2lOoPaO9+HsIvpwQHMxKpmk6irB8NX5QOM+iLhdIagaqeohAp4+LKHgjKUERuQ9D60HMgU
        k+Sl5Dug==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mW9x5-00DXb0-2Q; Fri, 01 Oct 2021 04:15:22 +0000
Date:   Fri, 1 Oct 2021 05:15:15 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Yanling Song <songyl@ramaxel.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] spraid: initial commit of Ramaxel spraid driver
Message-ID: <YVaLU+1oD7mlYRWJ@infradead.org>
References: <20210930034752.248781-1-songyl@ramaxel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930034752.248781-1-songyl@ramaxel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 11:47:52AM +0800, Yanling Song wrote:
> This initial commit contains Ramaxel's spraid module.

This is not a SCSI driver as it doesn't speak the SCSI protocol.  In
fact it looks a lot like NVMe with weird enhancements.

The driver also seems to have a lot of copy and paste from the NVMe
code without any attribution.
