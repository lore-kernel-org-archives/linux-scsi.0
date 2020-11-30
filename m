Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742ACC64E7B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 16:31:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3623B206F9
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 16:31:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgK3Qas (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 11:30:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:58770 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgK3Qas (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Nov 2020 11:30:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4A9A9AC55;
        Mon, 30 Nov 2020 16:30:07 +0000 (UTC)
Date:   Mon, 30 Nov 2020 17:30:06 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Tom Rix <trix@redhat.com>
Cc:     njavali@marvell.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: remove trailing semicolon in macro
 definition
Message-ID: <20201130163006.fvr4rs7524fymihu@beryllium.lan>
References: <20201127182741.2801597-1-trix@redhat.com>
 <20201130091753.4wyrzlbrqszdzy6s@beryllium.lan>
 <3baa674f-ce34-34a9-26ec-1d3e0e2ebdcd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3baa674f-ce34-34a9-26ec-1d3e0e2ebdcd@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >>  #define QLA_QPAIR_MARK_NOT_BUSY(__qpair)		\
> >> -	atomic_dec(&__qpair->ref_count);		\
> >> +	atomic_dec(&__qpair->ref_count)		\
> > Nitpick, please insert an additional tab after the remove so that the
> > backlashes align again.
> 
> How about removing the last escaped newline and the next empty line ?

Yes please.
