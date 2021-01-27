Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5088C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 16:06:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B4DA207D2
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 16:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236963AbhA0QGW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 11:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbhA0QEU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 11:04:20 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB74C0613ED
        for <linux-scsi@vger.kernel.org>; Wed, 27 Jan 2021 08:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=AxZXVouXfj8v1gKEZiddIvD1RbahnhbCKAWarlq1ens=; b=HYVwQiLf/A3FSe3g1DjfElMI6o
        rfGuETSnwhMbL1vD9zyP3E/gY1n1ulGwA2Vyg+DQwp0BSSm+8GD1zc0mmlYm5dvZ8/Sk4VGKZPi2P
        MWBN1y7ekUdNmY9UIr4hmXrGVQrTp73fi+PDlaavMgku/hzq+Cfs1+TERnqyut3JBXtaVLzeGLZqA
        kF5zPTgRfP5G7ujCSYi1vUOBfcSDgCEgxaOBz8wKuGdf3nWfPs5pWU2V24exCQnqdVnizXmBq5Cwn
        PHijBTGrvMro1xj98BnkCG06qd1xv1lgI91cSvvtJaTNOg9SASschT0H7tb3wsMJ1CURskUZMBZYw
        FYUcBHdA==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l4nI4-007DAn-A2; Wed, 27 Jan 2021 16:03:33 +0000
Date:   Wed, 27 Jan 2021 16:03:32 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Kiwoong Kim <kwmad.kim@samsung.com>
Cc:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Subject: Re: [PATCH v8 2/2] ufs: exynos: introduce command history
Message-ID: <20210127160332.GA1717731@infradead.org>
References: <cover.1611642467.git.kwmad.kim@samsung.com>
 <CGME20210126064508epcas2p3c1132f7b6895d344784629a0d2e74c12@epcas2p3.samsung.com>
 <d2e077fc8e8cd49ada614a08bb3dda85e8222c8f.1611642467.git.kwmad.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e077fc8e8cd49ada614a08bb3dda85e8222c8f.1611642467.git.kwmad.kim@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This code looks fairly generic and not actually exynos-specific.
