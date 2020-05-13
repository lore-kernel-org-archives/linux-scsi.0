Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C67DC2D0FD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 13:35:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49B8522210
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 13:35:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b0sAJvuL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388661AbgEMNfy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 09:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388063AbgEMNfy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 09:35:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71D3C061A0E;
        Wed, 13 May 2020 06:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=b0sAJvuLds/gvuq42NW7Pz3chO
        OGLRXWYDUwsJ8GiI1GecWpIUFYndGm8pQtZ+KYvHIadI8gwuzmjuQh8g5ZPQSXwJSCE7VPmHIx8+o
        kD/7z7IcZj7qHC900WRa4pQgbbtE4Vv2hy3scy9jjbDnDLMjXMu7rz11Z9ld7rtIjrb3p9CUfSzpm
        lr/yKckNrkCgSbk/PS3X0pqumDwsVwbyUf1CLmaT1yUyrmLXb00gR8ZmO4+8xsgw9kEz/XNw7+zLD
        K8oQdobkx8nGQzzraegImAk86LzuHNSs/rffe9EGgdJxrlY0lVNKoqA33vitrRX86ryXemxVuz9nK
        a3cowTfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jYrY9-00061W-GI; Wed, 13 May 2020 13:35:53 +0000
Date:   Wed, 13 May 2020 06:35:53 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH v12 02/12] block: Keyslot Manager for Inline Encryption
Message-ID: <20200513133553.GA10793@infradead.org>
References: <20200430115959.238073-1-satyat@google.com>
 <20200430115959.238073-3-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430115959.238073-3-satyat@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
