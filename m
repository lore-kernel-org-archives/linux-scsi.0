Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88561C48BDF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 12:42:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A734613FA
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Jun 2021 12:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231426AbhFXMoz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Jun 2021 08:44:55 -0400
Received: from verein.lst.de ([213.95.11.211]:54431 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhFXMoy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 24 Jun 2021 08:44:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C97867373; Thu, 24 Jun 2021 14:42:33 +0200 (CEST)
Date:   Thu, 24 Jun 2021 14:42:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     axboe@kernel.dk
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/2] nvme
Message-ID: <20210624124233.GA19981@lst.de>
References: <20210624123935.479229-1-hch@lst.de> <20210624123935.479229-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210624123935.479229-2-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ignore this (second) patch, it just was in my local tree for testing.
