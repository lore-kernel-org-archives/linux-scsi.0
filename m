Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 078D3CCA479
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jul 2022 04:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiGGEif (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jul 2022 00:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiGGEid (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jul 2022 00:38:33 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FC7A474;
        Wed,  6 Jul 2022 21:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bc3tDYkfIItiaG+hm2NxNZurGkQ6HmmInzDZ/5y0u0U=; b=TekAsi+GHhxkYKxyPSnPrqBFib
        Z9ELFm64IIa1moavS1o6iWhzT4LUUbN9xeP3DJQYrhZ2Y2p4q35egA7rQS8r0WehyLoseLZwYr/q3
        ZEQmzRgujtExGwolVGysFCcW3LZQ9QxQ6RGWDIR120Qi5DdgeSwRXOHbm2I6L2clUuZaXDnovX59B
        roSCa9ugpDA4UvBlD7b3zgfUGRXYQFRMe7IaZCn79nnJbsCw0Yj5T/WQk9oZbGBRyxlBdtQ38Ioid
        RTQG3gORFr/mzh0fhQs6+2W7yhm30s/3uIh/Vpk88SNfl6vgKsiABa/OnqFA2kZtcHLzIupbGpgMP
        g5NksOJg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o9JHR-00DVk5-Tm; Thu, 07 Jul 2022 04:38:21 +0000
Date:   Wed, 6 Jul 2022 21:38:21 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Mike Christie <michael.christie@oracle.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        John Youn <John.Youn@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH 00/36] usb: gadget: f_tcm: Enhance UASP driver
Message-ID: <YsZjPZxQZYhZ34Vh@infradead.org>
References: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1657149962.git.Thinh.Nguyen@synopsys.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

You probably want to split this up a bit to make review easier, a
natural first series would be target core improvements that can be
used as-is.  Also please don't just Cc people on individual patches,
which makes reviewinging impossible.
