Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB07C7EE24
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jun 2023 15:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbjFBPTO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jun 2023 11:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbjFBPTN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2023 11:19:13 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560A718C
        for <linux-scsi@vger.kernel.org>; Fri,  2 Jun 2023 08:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=PMNmgpSspMOUWKnuT9nAq/1E/sj45v7g+3FrIRz57Dg=; b=flprYJJoNltN2UYwIZE16ML6js
        EknzlVQKVoHk47mRZyA8tC+FgEAPTliVV7Qh9xMkShG7+ppdpBELXvhAp/oSsHb1n44Msm51PgBIZ
        G/kZNPenoz1TD8O+39C68eAKrEqLfEK5NTdjE4mMU0wBs7ls8zdAnOVPk0O48CGwy2RiDraZSw6N9
        vs7dYgvci//GIBLSw6HpGQIZvzVmaSQ0U1fUZu0tcJyTl1vLbE83caBJn/A/JGzRKjc6HpvnRCNS9
        zZieZV9woNhhXxqQ3OnlHZ188qTeUnk2OHZOmpRNwJrglR0qciOpraQwtvqSPvFrO7wU7rg2iNNcW
        Zs68urOQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1q56YV-007Eg9-1m;
        Fri, 02 Jun 2023 15:19:07 +0000
Date:   Fri, 2 Jun 2023 08:19:07 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Adrien Thierry <athierry@redhat.com>
Subject: Re: [PATCH] scsi: ufs: Include major and minor number in command
 tracing output
Message-ID: <ZHoIayr4wtYwQEHq@infradead.org>
References: <20230531223924.25341-1-bvanassche@acm.org>
 <ZHgrYgDmvhs7Iw/d@infradead.org>
 <2490926f-d8cc-3ce4-7a00-b8db58c89848@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2490926f-d8cc-3ce4-7a00-b8db58c89848@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 01, 2023 at 02:12:04PM -0700, Bart Van Assche wrote:
> I will look into removing the GROUP ID information from the UFS tracing
> output. Do you agree with adding the GROUP ID information in the SCSI
> tracing output after data temperature support has been added in the block
> layer and SCSI core? As you probably know the T10 committee recently
> approved Ralph Weber's Constrained Streams proposal.

Yes.  It might take a while for that with the speed of the committee..

