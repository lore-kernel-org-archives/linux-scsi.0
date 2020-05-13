Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799B6CA90AF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 11:08:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 646282078C
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 11:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgEMLIj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 07:08:39 -0400
Received: from verein.lst.de ([213.95.11.211]:45805 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728101AbgEMLIj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 07:08:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id F2AB568C65; Wed, 13 May 2020 13:08:35 +0200 (CEST)
Date:   Wed, 13 May 2020 13:08:35 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Jens Axboe <axboe@kernel.dk>, Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christoph Hellwig <hch@lst.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        linux-ide@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: sata_rcar: Fix DMA boundary mask
Message-ID: <20200513110835.GA4739@lst.de>
References: <20200513110426.22472-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513110426.22472-1-geert+renesas@glider.be>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
