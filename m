Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D977AFA372C
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 09:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A3934214D8
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 09:50:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o0NGdfsH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733267AbfKGJup (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 04:50:45 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60704 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfKGJup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 04:50:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=o0NGdfsH47PZ/7pGfS6Ty6ybm
        1ZQbSjKF3MlhHwKD0l7THem/DWE+herz5cCbvqsLKFD3Ugqyb8+fg6AECNJ36Rzw4uiqE3ksl8z+G
        uhps7EXD3om41yvx+Ypt5F8T6KRDNAq33t9kzhFtVt0rtwtKf6vMcuCmaVHlXDtoVbO9RjkGhtiUd
        GKi+8vbHSekn6DKILJ+Od+IxzbrVYIcCbSsoRw4bo64XdVuo3x0TIO007fBds1jbpt2Ovvo26E+CK
        EiWB3tv+kX1mjsrNxhbspwW3VDR8tRsmROIXXm+sOFB9ck3uDjUgOyrCl1B+2Xpj6McnMxptHVQcd
        Uq+60Ek2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iSeRB-00022c-4U; Thu, 07 Nov 2019 09:50:45 +0000
Date:   Thu, 7 Nov 2019 01:50:45 -0800
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
Subject: Re: [PATCH 1/8] block: Remove REQ_OP_ZONE_RESET plugging
Message-ID: <20191107095045.GA2024@infradead.org>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
 <20191027140549.26272-2-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191027140549.26272-2-damien.lemoal@wdc.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
