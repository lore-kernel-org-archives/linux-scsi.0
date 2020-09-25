Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B17EFC4363D
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 04:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AE6D21775
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 04:21:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgIYEV2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 00:21:28 -0400
Received: from verein.lst.de ([213.95.11.211]:54569 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726758AbgIYEV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 00:21:27 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8D89F68AFE; Fri, 25 Sep 2020 06:21:22 +0200 (CEST)
Date:   Fri, 25 Sep 2020 06:21:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Matt Porter <mporter@kernel.crashing.org>,
        iommu@lists.linux-foundation.org
Cc:     alsa-devel@alsa-project.org, linux-samsung-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-doc@vger.kernel.org, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mm@kvack.org, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        netdev@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: a saner API for allocating DMA addressable pages v3
Message-ID: <20200925042122.GA9577@lst.de>
References: <20200915155122.1768241-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915155122.1768241-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is in dma-mapping for-next now.
