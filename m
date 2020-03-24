Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7370C4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 09:19:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D12820A8B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 09:19:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="aMzNsCDy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgCXJQx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:16:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46556 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgCXJQw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 05:16:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=eUbWhFyFYKh/D+EH2xAXI6yOwQWJuIrgcf82enCj13Q=; b=aMzNsCDya4WzoS1mLkgOcJyIqR
        ThiXHq6FJCOKWtF4OTHWj9CAQWOr+ds1pY26M1kFWJ2mr696Sj4xNbDxF0ij/y8kqiKDxmZ5Vpad/
        gm1SMqL2C9yuXNZ1QlIkH5jbd4OvqGVHVVUqEvG3HED+FEUxP37MJOyNFH9VrPFbkzpy1zUnPSovf
        51xPtbRzqJuxNVhL1MrdAwgnVwElv0VXyPN/pZ/1odOkQlUeGkalgQPh4HErgqDkLsDjyKdt7XEU/
        ceEBFlYnNJ+CBcvkojoGJXdleB+nrbiNtbmb1+303n7o50kc5yuRoiCe4K9XjWycTFUf+xHt8IQBG
        Ili/XztA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGfg4-0000RN-8m; Tue, 24 Mar 2020 09:16:52 +0000
Date:   Tue, 24 Mar 2020 02:16:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Subject: Re: [RFC PATCH 4/5] scsi: target: increase XCOPY I/O size
Message-ID: <20200324091652.GD18399@infradead.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-5-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323165410.24423-5-ddiss@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 23, 2020 at 05:54:09PM +0100, David Disseldorp wrote:
> The I/O size is already bound by dev_attrib.hw_max_sectors, so increase
> the hardcoded XCOPY_MAX_SECTORS maximum to improve performance against
> backstores with high-latency.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
