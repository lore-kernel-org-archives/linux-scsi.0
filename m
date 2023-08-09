Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF86C0015E
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 13:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbjHINmS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 09:42:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHINmR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 09:42:17 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9E91986
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 06:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H73jBM+JRqSw3iv6ao36F/YNYm8fw+Tg6/G/nZkX7Rc=; b=dsQ+/4S6JO1DUHTM1gqnH/GORD
        bduelwzWLqUp3bv5U0v/kyqgdpofeR5MPwyH78JL9FyalrajYkNAt3Sqx3aGmiLElvj0YYTCJ5d1c
        ETaIvH45VqikUxT4w38LUiL0wPds7UJrDA9LD2uoABU8H/e4T7p6C5yhntGF807hhxSrq4yYCLZsT
        S6ZNi4NKBhrho3tLFXwC1vMQ05oDSEONW0vupb1ubrfn+sDJDcYn9n7y4H/Chu28hCdLh5uT44dly
        CDq9YRQcdSAXLobHjCYMrVUnHVGdXyXKMIc9FldPb80gvqM9kaHgh2aaMqtuFxD77pXj5mpFlWPbh
        PHoeuJ+w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qTjS2-0053uc-1Q;
        Wed, 09 Aug 2023 13:42:14 +0000
Date:   Wed, 9 Aug 2023 06:42:14 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH v2 01/10] qla2xxx: Add NVMe Disconnect support
Message-ID: <ZNOXttYtrwgxaBLc@infradead.org>
References: <20230807120958.3730-1-njavali@marvell.com>
 <20230807120958.3730-2-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230807120958.3730-2-njavali@marvell.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I don't see how this could go in through a driver pull request.  You
first need to convince the nvme maintainers that disconnect support
is a good idea and actually support it properly in the nvme core.

