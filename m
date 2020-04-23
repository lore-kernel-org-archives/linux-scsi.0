Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1404CC2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:55:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E487421582
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dRhJAeFR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgDWHzC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:55:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHzC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 03:55:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 559CCC03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=dRhJAeFR2yS07U1bPqn5b1Gb5d
        n5o+ARB3hV129xs17Lzk8iYhWsDhroPBvQXognYHuoR9XLP7XmsdIK17qnMtpoR3oJoqxVyZXC8cg
        Adyxxyc2Mut736CYphexRiBVIHgKjCw2hIoPzoMh/qbCnxV5+hd8rAuUbCfhGUIs0DAks7amL6e2U
        BFaN/W+lir9ZkmBW4hqxYlPOCPfB+j76BDCtszAGPojJCup2xwehmss6/GZDWcX2Rcrzk78JXy/Ut
        GrC7hC7R8x3ozYC0ZZyFXd5N+Dj8i6FuDxsMhQNHIBUi0JGwSXxkUXKZ7FMw6O5ovfx4ajc71DK41
        0e7lykeQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jRWhK-00018B-4M; Thu, 23 Apr 2020 07:55:02 +0000
Date:   Thu, 23 Apr 2020 00:55:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, hch@infradead.org,
        Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com
Subject: Re: [v2 4/5] mpt3sas: Handle RDPQ DMA allocation in same 4G region
Message-ID: <20200423075502.GB5229@infradead.org>
References: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1587626596-1044-5-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587626596-1044-5-git-send-email-suganath-prabu.subramani@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
