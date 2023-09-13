Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07350EDEC4A
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 12:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbjIMMZY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Sep 2023 08:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjIMMZX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Sep 2023 08:25:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A03C19A8
        for <linux-scsi@vger.kernel.org>; Wed, 13 Sep 2023 05:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aj0K39ehIPVhCISlklRRt97cKOxbG20VbGIU5SLYTe8=; b=rSK5QQFy0l0VjaoJHzfaJ4zahQ
        QGCWVLwr7WpB4gEjzOb9UmkxqpTsAmEQhugyV9cskdriYaY8gHMCscBnbkPMibM4uypezGnQkEf46
        YOyBoruahcn9CbYtBREW9i2TeNrK+nVXsiNGoHMNhGWIsQ83jOI+sgqE9BJO2wZ8DnauCASuB6fSN
        W3IhV+RqWWzLVI9A2LEQvmoatN235JT+l76d3nhKdVmcNuS6+zyzIHCnC+VTxSwsnhymow451uNNk
        /QmcXc9fp/LHe+T9sDlu6eYQaIW6BUiv/aJBkipG8OSn/0k+j67OajsQNeuLorGxVG9oOrZmf+9Fv
        3r/g+TEQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qgOvl-005qxn-2g;
        Wed, 13 Sep 2023 12:25:17 +0000
Date:   Wed, 13 Sep 2023 05:25:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com, agurumurthy@marvell.com,
        sdeodhar@marvell.com
Subject: Re: [PATCH] qla2xxx: correct endianness for rqstlen and rsplen
Message-ID: <ZQGqLUEqQrJ+d11Z@infradead.org>
References: <20230831112146.32595-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831112146.32595-1-njavali@marvell.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can we please get this to Linus ASAP?

