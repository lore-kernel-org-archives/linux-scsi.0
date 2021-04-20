Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51E02C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 06:34:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29EFE610CC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 06:34:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhDTGe6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 02:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhDTGe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2021 02:34:56 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E826DC061763
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 23:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9AIf60KwxstqxL5VzH0hxnW7EMiPQdedy+zehr4LoHc=; b=qZLWJcYSD5suhTIlMTqgRB+IH6
        pGkiwecyeKy5QHhLnmXBm00eckTaxN+ViM75l9/61c+U0u1p8iTILyR8BWg6XRmiGTC6HUCdEpQW+
        uuIvWq2soxp3lTew6syaLVUgGqj6sg8IzIA/l0eWj7JR/Xu/TWAiZfxvyDcO79Y1kOmIew7mHYvlj
        MjS/oa1vecTvIrUi1vcA4OsVofQBiZiMshGV674U+PMg2V9PQpI6M9zpETbf3anaecfC/qEzYOEeE
        aVDxBdLqkgjU/0Hd/fvxB1yiy1AxeKhdZhgDJ0inPm0VPY+Nz6HTufmwFVqBiMIso3JLbijlVjW0H
        a1+F+XHw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYjwr-00EoCd-Pr; Tue, 20 Apr 2021 06:33:44 +0000
Date:   Tue, 20 Apr 2021 07:33:25 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: Re: [PATCH v2 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
Message-ID: <20210420063325.GA3528859@infradead.org>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-2-kashyap.desai@broadcom.com>
 <32dd1ee9-4172-50b9-493c-181ae66da11c@acm.org>
 <39cd58b5a03db494176f2f1df1ef365c@mail.gmail.com>
 <ce374ec3-754f-e36d-f844-088ac17535b0@acm.org>
 <15a1b800b7b3f2ab52e189700b07f412@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15a1b800b7b3f2ab52e189700b07f412@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 03:50:50PM +0530, Kashyap Desai wrote:
> Hi Bart - This is possible to modify, but I have to forward this feedback to
> group who owns the MPI header within a Broadcom.
> It will be difficult to accommodate requested to change in this series.
> 
> I have marked your feedback as TBD for upcoming driver update (not in
> current patch set). In V3, this is not accommodated.  Hope this is OK with
> you.

Please stop this crap.  There is absolute no reason at all ofr this
mess.

Please just write a normal driver with a hand-generated header.  That
requires less work than all the arguing here and means people can
immediately jump in and actually understand the driver, unlike the
current train wreck.  And looking at mpt2sas/mpt3sas is is pretty clear
that the comon header scheme does not work at all.
