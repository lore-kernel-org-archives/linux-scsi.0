Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08BCCCA90AF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCA5320673
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 18:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589306812;
	bh=FSuhoMdxsv0/TzoZBEjHyNleiPV8NffmxdAM5VCVxWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CNqLR0YbwM3XFnl3weeGF2xMM0bbjVHUppBMSqe8quwyjmBGNGswV5VH5u7g4pDwI
	 dgKvnY6tqpjHhncKtCzXA5vrFND75qDXnKxoz4ll+7+pez+jTJQBi1gdOhHfYACltX
	 0/t2QcaXTwrYSMwtthYJqW9tV+Ck+71CB0DGZgqY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbgELSGt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 May 2020 14:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgELSGt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 May 2020 14:06:49 -0400
Received: from embeddedor (unknown [189.207.59.248])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 939E920673;
        Tue, 12 May 2020 18:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589306809;
        bh=FSuhoMdxsv0/TzoZBEjHyNleiPV8NffmxdAM5VCVxWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+S93CRiWGAmMaWQoLzGhtLA6RofE+iU4btmBQPiip25uBYf45ZMB6ufRnaFA0YEe
         Kz/3kVi6UKI5qP4+h+rUp7lwtt2k3XclFUoNm74klSYGVSXjQzWfaTe7jBEvtC0vMH
         tSmiTDWe7mCmI+d3SYlKh3HTTrM8dRp4mxG/acR8=
Date:   Tue, 12 May 2020 13:11:23 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: Replace zero-length array with flexible-array
Message-ID: <20200512181123.GH4897@embeddedor>
References: <20200507192550.GA16683@embeddedor>
 <158925392373.17325.7271834544265076683.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158925392373.17325.7271834544265076683.b4-ty@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 12, 2020 at 03:28:31AM +0000, Martin K. Petersen wrote:
> On Thu, 7 May 2020 14:25:50 -0500, Gustavo A. R. Silva wrote:
> 
> Applied to 5.8/scsi-queue, thanks!
> 
> [1/1] scsi: ufs: Replace zero-length array with flexible-array
>       https://git.kernel.org/mkp/scsi/c/ec38c0adc0a1
> 

Thanks, Martin.

--
Gustavo
