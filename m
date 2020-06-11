Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2699C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 05:43:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CC4FC2074B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 05:43:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgFKFnN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 01:43:13 -0400
Received: from verein.lst.de ([213.95.11.211]:49316 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725300AbgFKFnN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 01:43:13 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D7C266736F; Thu, 11 Jun 2020 07:43:11 +0200 (CEST)
Date:   Thu, 11 Jun 2020 07:43:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     john.garry@huawei.com, brking@us.ibm.com,
        jinpu.wang@cloud.ionos.com, linux-scsi@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: Re: [PATCH] scsi: wire up ata_scsi_dma_need_drain for SAS HBA
 drivers
Message-ID: <20200611054311.GA3607@lst.de>
References: <20200610064540.269738-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200610064540.269738-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'll need to do a v2 as this causes undefined references when libata
isn't enabled.
