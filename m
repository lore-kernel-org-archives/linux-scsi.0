Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 030BCC32771
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Sep 2022 15:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiIZP4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 11:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiIZP42 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 11:56:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFB027CD6;
        Mon, 26 Sep 2022 07:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=BF7TrxuHg8VWiYmnBgXSU6xi1GIgMGkhEuKcEkcRrWE=; b=q61X2kGQOlVfPdGfzQdHZqrsCF
        ULKFTNsWkXfI2CSbw+m8C6cPDhxKHtFx7Ou4f4IomDUl6Q8PAYMHLUYrBwkindPLwfYZGXjtGwxiL
        6Dwn7dV07rPVdhWVuGcsAh6uJmn1suURXynjiKRFbAhiJ9li8AITYB3pSsPmr2plAZEpxAlIeZjDD
        91j2EAR0fCWShBW6NYf/qm4/JIdnodSl4SiCo8jIVho9yOJQIw5PIjoIpcI63wOiyKvm8O+Bj/4g7
        60n5qzcxb62SNOl9YKCsB550EGuEJbGhbgbUoY6+ya2vIjWNmSUblwqC1Dg+FFT+VBoQC1MLc1LN4
        5YbU764w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ocpKb-005R8Y-Gx; Mon, 26 Sep 2022 14:43:37 +0000
Date:   Mon, 26 Sep 2022 07:43:37 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Stefan Roesch <shr@fb.com>
Subject: Re: [PATCH 4/5] nvme: split out metadata vs non metadata end_io
 uring_cmd completions
Message-ID: <YzG6mZhtd/QysvdH@infradead.org>
References: <20220922182805.96173-1-axboe@kernel.dk>
 <20220922182805.96173-5-axboe@kernel.dk>
 <Yy3O7wH16t6AhC3j@infradead.org>
 <d09e1645-919f-9239-f86d-a8e85a133e5c@kernel.dk>
 <YzG5/1zSdiMlMLnB@infradead.org>
 <69598e37-fb91-5b92-bb80-b68457a7b6f8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69598e37-fb91-5b92-bb80-b68457a7b6f8@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 26, 2022 at 08:41:38AM -0600, Jens Axboe wrote:
> Sure, I don't really care. What name do you want for it?

Maybe slow and fast?  Or simple and meta?

> 
> -- 
> Jens Axboe
> 
> 
---end quoted text---
