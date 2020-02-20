Return-Path: <SRS0=qpW3=4I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA878C11D0C
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 17:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C592A207FD
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Feb 2020 17:24:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgBTRYd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Feb 2020 12:24:33 -0500
Received: from verein.lst.de ([213.95.11.211]:50627 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727979AbgBTRYd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 20 Feb 2020 12:24:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 32E9768C4E; Thu, 20 Feb 2020 18:24:31 +0100 (CET)
Date:   Thu, 20 Feb 2020 18:24:30 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: Re: [PATCH 1/2] ufshcd: remove unused quirks
Message-ID: <20200220172430.GB14530@lst.de>
References: <20200218234450.69412-1-hch@lst.de> <20200218234450.69412-2-hch@lst.de> <20200219003056.GA213946@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219003056.GA213946@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 18, 2020 at 04:30:56PM -0800, Eric Biggers wrote:
> On Tue, Feb 18, 2020 at 03:44:49PM -0800, Christoph Hellwig wrote:
> >  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
> >  {
> > -	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
> > -		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> > -	else
> > -		ufshcd_writel(hba, ~(1 << pos),
> > -				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> > +	ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> >  }
> 
> This part is keeping the quirk version.  It needs to be other way around.

Fixed.
