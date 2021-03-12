Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17EEFC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DAD316501D
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhCLQlB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:41:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbhCLQkk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 11:40:40 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D82C061574;
        Fri, 12 Mar 2021 08:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=l2WBiCb5duYJRA9nKpihqrJOH1Qjg6utSrFiu8qAdtc=; b=hPwtzBU/B5uu8HJaDqauIHoNOo
        seyRaDJyZ19QIJr2XV+6n9DQa76FsGg7wmiMRRCnduQsW9xIW5y27MfncIHxTPZJ3R8RmxF7MLz/U
        HQRL9XvXBpfvkVotjbcQSEliKJNZudlmUhpa4HHZC5DmtVdG744eZ4F4dvi2+i84MwXTG0R7YzBfN
        Si4CweoxrCfsveSqk/48BuosMF2nRsHVD24BgB1B+c9OvhKA62TqcMWcpmtai8kU5Zgo597nwQ0Kr
        RbMiRCag797bMnY2bod85D+qCZdVKgVsJCTkvUCLrjlujQ5sGGnkLvK6lcCoWijhH0FoawRLq1jAg
        Llh/ig1Q==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lKkpx-00B9f6-K9; Fri, 12 Mar 2021 16:40:33 +0000
Date:   Fri, 12 Mar 2021 16:40:29 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org, Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Linux GmbH <hare@suse.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 27/30] scsi: myrs: Remove a couple of unused 'status'
 variables
Message-ID: <20210312164029.GA2657272@infradead.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
 <20210312094738.2207817-28-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312094738.2207817-28-lee.jones@linaro.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
