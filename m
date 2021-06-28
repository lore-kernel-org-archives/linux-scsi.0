Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89FEC2B9F4
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 09:57:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC08E61584
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Jun 2021 09:57:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232558AbhF1KAB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Jun 2021 06:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhF1KAA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Jun 2021 06:00:00 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35784C061574;
        Mon, 28 Jun 2021 02:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=qIbUFExBlJI5QA1nU2WzaI4H72pC0gc6gNk0xgR+rKc=; b=P67bAxKgnCNb4it+mmUn9RXFur
        8YhmJ0KuWIUz8sQi0gHjJGwVa9pFqfA+MrWJqN52N2IHhHOWPsBb3AKXG1toUqLubnxKCJGQpaohm
        wE4bdavEkuw68XocSlav0FoQ4eXqz+O9efzE/WBB0lB2LKWsBA3p1IfQgCJXy7ulG9nFwTK8EINRC
        Qa1HlsRv0V1LxdbLyRkLFeamdOfxBD8w0Xb+wO5oFxxcaEgI0Qj3sdMADAJALRZioq6BFr7R1ZKVL
        rOtpCQw20ssWCvqk2ZoD3qa3ugxA75tY9epUZuPCZjRg2tF03LdvGXuwBubvStyTJ87fYdkyLDoLD
        O+yN5pvA==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1lxnxm-002ntY-LZ; Mon, 28 Jun 2021 09:54:15 +0000
Date:   Mon, 28 Jun 2021 10:53:58 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Igor Kononenko <i.kononenko@yadro.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        openbmc@lists.ozlabs.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 5/6] FMS: Add the SCSI Get Configuration command.
Message-ID: <YNmcNvqvTFNCrMl9@infradead.org>
References: <20210626211820.107310-1-i.kononenko@yadro.com>
 <20210626211820.107310-6-i.kononenko@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210626211820.107310-6-i.kononenko@yadro.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

What is FMS?  And why do only patches 5 and 6 show up on the list?
And why does this mix changes to the SCSI layer, libata, usb-gadget and
the CDROM UAPI in a single patch?
