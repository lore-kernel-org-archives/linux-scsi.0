Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EEDAC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 08:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345877AbiCOI15 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 04:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239420AbiCOI14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 04:27:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4413981F
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 01:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r2rFRtqPE+jcua+Ud1+u4R7KJYtkOEOtSqvwewp6yy4=; b=MhMDXSxq7C1hj/Gbl29lHYgwa1
        fcr4ivtx6Zs68mMluT1GaIpv31tAuVcIVQ9+h4WFozbRw7fBUExkFA0DisQKYTri/vnecFCWvTDbm
        ws4UdgjD64yQ3Ic5HxJ02YDPNJ0cltg50nx31eTihBN7DmhVihRQ2toH6yv+8tIDvhWYR38i+G8aW
        VzYRrU65Fevxklx2QCPp0qTdZ+H77PTN+4fIhyYyQqqmh2zle8A0q6bwUS3UF6aBmk0zn4HYpDtNM
        gv39bykhojC4GZcYPJcdG1ZWAoXLdTwnK+XeVdaoAAwXy4I6KnC/+I5VF750oSJGbbk8sR+dZxazS
        ylURxkvg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nU2Vs-008GBQ-L5; Tue, 15 Mar 2022 08:26:40 +0000
Date:   Tue, 15 Mar 2022 01:26:40 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        ming.lei@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
Subject: Re: [RFC PATCH 0/4] scsi/iscsi: Send iscsi data from kblockd
Message-ID: <YjBNwMp3WlkjFd0g@infradead.org>
References: <20220308003957.123312-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308003957.123312-1-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The subject seems a bit misleading, I'd expect to see
BLK_MQ_F_BLOCKING in the subject.

Note that you'll also need the series from Ming to support dm-multipath
on top devices that set BLK_MQ_F_BLOCKING.
