Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B40C00140
	for <linux-scsi@archiver.kernel.org>; Tue,  2 Aug 2022 13:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236769AbiHBNdr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 2 Aug 2022 09:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiHBNdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Aug 2022 09:33:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D220C19291
        for <linux-scsi@vger.kernel.org>; Tue,  2 Aug 2022 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=9mLt+RbQYkmy8DQsGzGLE2i0dfkA+2EO8P2MffsOJ/c=; b=k4yCd3Di/nCqaxTgICRIbI+Fh9
        xZb6RIYp11HRWc26zCUdZZSQAbmpI3oPFfHLt6tQmDJf0qa8i3fxNY+msSRrE0lAjqkOCucTdKf2K
        2EtpwJhqv54gbQd4j+/xcTp2SXm/cTJGlBknGCAoDS1ZSbXkptOYzMQ79VXMjFwtbwSGqeRe8QTXr
        6/jpEOU3kNGIPOrpmVpqK7OPFWp7SCkvKxHmqkaedTvri9NhPTLbLGsV/OfV1edEisT0MRhXor405
        px/b0oC7Yy6j0p5Bb/plR31XjgmVCp+L8Mtf3G0IWCPM5wLxscP4GCdZcihfwv5X4Po/n/iWq1l8y
        A730wdoQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oIs1l-00EUAf-Uu; Tue, 02 Aug 2022 13:33:41 +0000
Date:   Tue, 2 Aug 2022 06:33:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/4] mpt3sas: Increase cmd_per_lun to 128
Message-ID: <YukntYR+czw0JnWw@infradead.org>
References: <20220801124144.11458-1-sreekanth.reddy@broadcom.com>
 <20220801124144.11458-4-sreekanth.reddy@broadcom.com>
 <YugUOiB6k8rcH87N@infradead.org>
 <CAK=zhgoJJLshCb6VLgo1Htjg1BEw3FXtCJQkJVsAYGQ7Lu0mjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=zhgoJJLshCb6VLgo1Htjg1BEw3FXtCJQkJVsAYGQ7Lu0mjw@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 02, 2022 at 02:13:42PM +0530, Sreekanth Reddy wrote:
> On Mon, Aug 1, 2022 at 11:28 PM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Mon, Aug 01, 2022 at 06:11:43PM +0530, Sreekanth Reddy wrote:
> > > Increase cmd_per_lun to 128
> >
> > Why?
> 
> In one of the earlier thread (mpt3sas fails to allocate budget_map and
> detects no devices -
> https://lore.kernel.org/all/YdcZwVUFGUPgkbLn@T590/T/) it has been
> mentioned that cmd_per_lun with value 7 is so small and hence we
> thought it is better to increase it to 128.

Well, that is what the commit log is for.  I can see all by myself that
you are increasing it, so you need to explain why.
