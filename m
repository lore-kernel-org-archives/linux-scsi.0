Return-Path: <SRS0=qNH0=5X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA8AC2BA80
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:49:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30C3B2078C
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Apr 2020 16:49:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F8gEeAHS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbgDGQtV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Apr 2020 12:49:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:39230 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgDGQtV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2020 12:49:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=KkP0K71DHuFdQSQyDt0gFTCGMMTOSGpWSK11kH3Otbw=; b=F8gEeAHSGOBV36NUT7nKkI19hq
        E7tDM+IW8CKxkknwEaD4g658E8+Tr9KHX0LNdKF67BX5VE4FyHGI1dsKTA8iQEhRUjwTzq0rl2YGy
        T/fsYtaN772YYa0vPy6WCcIz1UOH5et0xo1k1fcFostXFGtu/8HBkHBfc1FTJtcSKn7nI8/uiR/zv
        E4BZ6Zm4XSkel75UC4/TZgyZWwf4F2EovBEd0LLj4LuEGlXF0bEY92SG5S1GKg+JqCYGFctQmMdeZ
        VTn65ohQ/Fn6Ol2ARjR8KfDO4naIMY/iNGIK2ZN8YsJvOl2+92SQTdJOy6yS7/6oOxbVeoHKpmtG4
        xV8dgqtA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLrPc-0004vt-18; Tue, 07 Apr 2020 16:49:20 +0000
Date:   Tue, 7 Apr 2020 09:49:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-block <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-fsdevel @ vger . kernel . org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v4 00/10] Introduce Zone Append for writing to zoned
 block devices
Message-ID: <20200407164920.GB13893@infradead.org>
References: <20200403101250.33245-1-johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403101250.33245-1-johannes.thumshirn@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Do you have a git tree available somewhere?
