Return-Path: <SRS0=d5MZ=CR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FB2C433E2
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 07:52:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC52A20C09
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Sep 2020 07:52:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgIHHwj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 03:52:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:50834 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728786AbgIHHwj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Sep 2020 03:52:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DDE45AE24;
        Tue,  8 Sep 2020 07:52:38 +0000 (UTC)
Date:   Tue, 8 Sep 2020 09:52:37 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Arun Easi <aeasi@marvell.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 3/4] qla2xxx: Drop unused function argument from
 qla2x00_get_sp_from_handle()
Message-ID: <20200908075237.tlx55lq344ui4z4q@beryllium.lan>
References: <20200831161854.70879-1-dwagner@suse.de>
 <20200831161854.70879-4-dwagner@suse.de>
 <alpine.LRH.2.21.9999.2009072343130.28578@irv1user01.caveonetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.21.9999.2009072343130.28578@irv1user01.caveonetworks.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Arun,

On Mon, Sep 07, 2020 at 11:46:27PM -0700, Arun Easi wrote:
 
> How about printing the "func", which gives an indication of the caller 
> function, in the ql_log-s, rather than removing it? At least in the cases 
> like you describe, it'd give an indication which handler the path was 
> taken.

I've added the func back. Though I think it would be better to make more
use of the generic ftrace infrastructure instead reimplementing a
tracing infrastructure.

Thanks,
Daniel
