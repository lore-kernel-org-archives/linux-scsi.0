Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53FDC11D2F
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 17:16:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B50A20836
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 17:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgBXRQP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:16:15 -0500
Received: from verein.lst.de ([213.95.11.211]:39226 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727090AbgBXRQP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Feb 2020 12:16:15 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 29D1368B20; Mon, 24 Feb 2020 18:16:12 +0100 (CET)
Date:   Mon, 24 Feb 2020 18:16:11 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Asutosh Das (asd)" <asutoshd@codeaurora.org>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 2/2] ufshcd: use an enum for quirks
Message-ID: <20200224171611.GA7278@lst.de>
References: <20200221140812.476338-1-hch@lst.de> <20200221140812.476338-3-hch@lst.de> <7f2394fb-d1fc-830b-eab7-30650c92e87f@codeaurora.org> <530c2c48-7bc7-1a8e-07b9-997854188f9c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <530c2c48-7bc7-1a8e-07b9-997854188f9c@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 21, 2020 at 06:45:37PM -0800, Bart Van Assche wrote:
> On 2020-02-21 10:18, Asutosh Das (asd) wrote:
> > On 2/21/2020 6:08 AM, Christoph Hellwig wrote:
> >> +    /* Interrupt aggregation support is broken */
> >> +    UFSHCD_QUIRK_BROKEN_INTR_AGGR            = 1 << 0,
> >> +
> > 
> > How about using BIT() here?
> 
> Not everyone is convinced that using BIT() improves code readability.

I for one am not. 1 << N shoud be obvious to anyone with a basic
understanding of C code, BIT() needs to be looked up.  And it isn't
actually any shorter.
