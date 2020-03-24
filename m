Return-Path: <SRS0=zrch=5J=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE787C4332B
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 09:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94568205ED
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Mar 2020 09:07:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="hpROMF27"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCXJHS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:07:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44072 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJHS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Mar 2020 05:07:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=7DRPoZTCN0RyssxWz0mHGwNWwy3f4hgr11EJ1CxTSSU=; b=hpROMF27E32eW4boZ/KQ3R8XAL
        IY04LHgsFYVz5KuqBoCdyk1/J2yIPlRbcME/dY9na8I/5FY+mLTHE5aKrSQDmZFlpFMH4twYHdc8F
        FQMfZsvyX4FC4cTGlxWjLzTSHXiqB1n0T8SCQ5gc6JwrEsK577FNga/7H7nuKtkZfK7Tc4SaRPkBj
        +zgN5xdViOJtYEFaQzBpkjth5WraI5bRkiVKc/APFuE6Bst3H5mh9FNm9gHns0WPMCXoimbcUrmx5
        uziKb0UUO2Ip3I1a4055+8uf2loZ+L0o568iEs5ZHWr9iRQT4OkuzDBoeDAIXRGp2gbsSncZxQVlR
        m2zmy6oA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jGfWn-0005FJ-RR; Tue, 24 Mar 2020 09:07:17 +0000
Date:   Tue, 24 Mar 2020 02:07:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Subject: Re: [RFC PATCH 2/5] scsi: target: drop xcopy DISK BLOCK LENGTH debug
Message-ID: <20200324090717.GB18399@infradead.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323165410.24423-3-ddiss@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Mar 23, 2020 at 05:54:07PM +0100, David Disseldorp wrote:
> The DISK BLOCK LENGTH field is carried with XCOPY target descriptors on
> the wire, but is currently unmarshalled during 0x02 segment descriptor
> passing. The unmarshalled value is currently unused, so drop it.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
