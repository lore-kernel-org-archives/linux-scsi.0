Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB1CC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42B1A64EA4
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Feb 2021 09:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbhBXJUU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Feb 2021 04:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbhBXJUS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Feb 2021 04:20:18 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DF5C061574;
        Wed, 24 Feb 2021 01:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=SkLPtHa+v4mfuxmmR3i6q2WWq0IwoOHrO5EYp5WwGQc=; b=a1LhwCmIveS0OBAfRew0dJEhDC
        T1HM4uYxq2JfWUFsUyPoJSmYqeawLknL2feNE9WUWYcETduvTx1DZs4er/XLibYOiH/J62AEjV9xw
        UPAheWoVe++mxix53lTehNZPXHG9CdVFo0yMLqXf50XL2dvVY8JaFuBp2JCp2kIfIE1EX+qmlt/3R
        UbRf+EAPTmMJ1iu0drBtqH5hok0hUJBQM1bxLnmv9zE3AhH4tInouuPBnsAfa1RTHw9WWmk66bYcJ
        f7jQf/NWYG2tOpxtVLPblWTll3RTutqzhkkD4h5qbOXi3kIOVzfJO6SWZfo6CQ0t41RnFfkCSOmZC
        ynsVGFjQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lEqKD-009DEe-7Y; Wed, 24 Feb 2021 09:19:20 +0000
Date:   Wed, 24 Feb 2021 09:19:17 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Zolt??n B??sz??rm??nyi <zboszor@pr.hu>
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        Zolt??n B??sz??rm??nyi <zboszor@gmail.com>
Subject: Re: [PATCH] nvme: Apply the same fix Kingston SKC2000 nVME SSD as
 A2000
Message-ID: <20210224091917.GA2194565@infradead.org>
References: <20210221051216.3398620-1-zboszor@pr.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210221051216.3398620-1-zboszor@pr.hu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thanks,

applied to nvme-5.12 with a slight tweak to the commit message.
