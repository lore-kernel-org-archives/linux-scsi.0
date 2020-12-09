Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28F72C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D84EA23B51
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 17:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbgLIRvp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 12:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgLIRvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 12:51:45 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F2A1C0613CF
        for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2020 09:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=kQ630RwNYw146YL40NcRtm81WZ
        OyYGq4u9Lt8B0oyJSo6OtmfMFRyDXNwkHFqIf4bZ7LmSOx1E2z/S3ROtxkZcdOhRYt639Q92T4pFY
        /FotT6wuGIMmZ6sLyhzz1Zih5bTV1rQl8onC8DYYUFnHURTN8O4MrjZ3GbpIBhg+OfNq9d3KifV8w
        2CdgW+osB/374mUud8mWrjk+gRdP8J8qyK5eo8dBBjNHQLoFibvJGjsEZyfF5lk3iQASPj4uei3ML
        jKwCnaPqKJf4VuRsR0YxiYYukfzsONLRIvwFvTd2BkukhYvV9b73J6KPX3CFAkGiI4AfEWQL105Bf
        DQg8vT6g==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kn3cE-0006h8-Np; Wed, 09 Dec 2020 17:51:02 +0000
Date:   Wed, 9 Dec 2020 17:51:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Ewan D. Milne" <emilne@redhat.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sd: suppress suprious block errors when WRITE SAME
 is being disabled
Message-ID: <20201209175102.GA25719@infradead.org>
References: <20201207221021.28243-1-emilne@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201207221021.28243-1-emilne@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
