Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5938C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:04:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 914DD221ED
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:04:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389226AbhALJE0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731246AbhALJEX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:04:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A20F4C061575
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 01:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XBKNWbQ0VDuq6yUObcVhuSk3WOxpO6jypaQpawlFoUE=; b=UTaNygP2hkFWo48TC1az00ld0x
        0+xU7Bj7jScBi885sbRQQwGfWKeXq9rxz30mWfqtA5y8HghJjqxaQq+CiCc6Z6/xl22RwxF6IDih9
        NJLBS/MkIgBdIv/YHn7AHPpoRIZsGNs8rMcz+d48B/U0hVXjrO2Igx5Ixnlpyj1L8XdCuJhUnqx5I
        r1RVrlDDc55sDr67lu8pCBeOGaa8d3YLQJyNYmtoj0xoDdSdSyJ9KeTP0d43zy8MABP5nfEAvvqwo
        J9VhaHKO1kvr9leNmox93xBGaBf6LSboCFDOxt3olHIChGkum8dym0lyoplBAc20F06UwKJzpriGr
        GY1uNxLA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzFa7-004YQb-UU; Tue, 12 Jan 2021 09:03:20 +0000
Date:   Tue, 12 Jan 2021 09:03:15 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [PATCH v5 2/2] ufs: ufs-exynos: set dma_alignment to 4095
Message-ID: <20210112090315.GA1084989@infradead.org>
References: <cover.1610419491.git.kwmad.kim@samsung.com>
 <CGME20210112025712epcas2p4f92af7bd5781df2fcefecca47d55bf8e@epcas2p4.samsung.com>
 <689878ebbad3e63a96b431df8d843264f8fe57ba.1610419491.git.kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689878ebbad3e63a96b431df8d843264f8fe57ba.1610419491.git.kwmad.kim@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Just use quirk instead of all these indirections.
