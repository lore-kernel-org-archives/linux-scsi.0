Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29620C5DF61
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 09:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF51A218AE
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 09:53:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JdCk1j8W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387874AbfKGJxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 04:53:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfKGJxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 04:53:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=JdCk1j8W08zy5gydXWSaeYKL2
        v3WlDLW1WbJJVItw9fyDU67drB8ASaut8a8zbDzkEBTDCvy98GKNqcuUw1ZP1IuNpp6k6EeG693Ft
        rfTlXLGXK2tfoHsL183fZ88EUDPDawrDK6zMNwWER6sjGx60akdE5hACf+mFV6zUPMnGvQFBJaIXa
        EOHbNfy4lBeCsJrj8b9ADwnOcCyYVCoQEauko8OOAxDg+Axp1bp085q3LZPRJw+R6s/56PjjImI7j
        mLMAFR8xnbOKz8OVFwluXE5+9oKGOst05B9LhJtjmKmrF3DKNEpO1zSff51EjqLQMDS+gqXoJOsbn
        9zhiIUqrA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSeTa-0002h0-1X; Thu, 07 Nov 2019 09:53:14 +0000
Date:   Thu, 7 Nov 2019 01:53:14 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Damien Le Moal <damien.lemoal@wdc.com>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Matias Bjorling <matias.bjorling@wdc.com>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Dmitry Fomichev <dmitry.fomichev@wdc.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 6/8] scsi: sd_zbc: add zone open, close, and finish
 support
Message-ID: <20191107095314.GE2024@infradead.org>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-7-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027140549.26272-7-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
