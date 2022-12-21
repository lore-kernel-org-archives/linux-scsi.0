Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DC1C4167B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Dec 2022 08:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiLUIaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 03:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234368AbiLUIaE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 03:30:04 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B60E1EEEB;
        Wed, 21 Dec 2022 00:30:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8o2dl4ijxnaplHp86fDPd2csqnysj6w/EhAfWcPqQcI=; b=ala1+9it2j9oUjd+IUL0Fg3RAc
        V6TGuA+Ha9KKb0Oda0aAtysmqpJeP8XadRd4yEcAWeYzeBH25K24bSoj+1htWQxU1nHwPl5yKVY8H
        RGCK0Ev4NRSqoUbuHNvi0LGLLW2W/dT55aiFDbyrpjVmZLIoqoA65Tzte4nNHn7TAvZ9BEJAWxY5o
        vd3BWmF8ImCKq1wgSDy1W4LZCnM94IoMN3YCo0Cu6lSCB9PzL6RvvcpJt2n5wnzKL6yJ/kPVw/6Oa
        xnAJ8j0sotip5GYarzj1w5rX0LGmug1F0JkOCDgTocMUdXg+4UyIL5I+CYWrHQvcFd5c2JDlZhDcu
        deGfaDDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p7uUC-00CAAx-4i; Wed, 21 Dec 2022 08:30:00 +0000
Date:   Wed, 21 Dec 2022 00:30:00 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Nikos Tsironis <ntsironis@arrikto.com>,
        Christoph Hellwig <hch@infradead.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
Message-ID: <Y6LECFb7wPn2Z0yJ@infradead.org>
References: <20220929115504.23806-1-ntsironis@arrikto.com>
 <ed3e5f22-dd2c-2952-dc7e-c47bccf66611@oracle.com>
 <Y5Dc66mOzBfBhUGY@infradead.org>
 <da4f53f3-4e13-1259-b0a6-cc28160be23b@arrikto.com>
 <6ae8a2b8-9720-8e60-4431-072218e57e28@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae8a2b8-9720-8e60-4431-072218e57e28@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Christoph is that what you were thinking?

Yes.
