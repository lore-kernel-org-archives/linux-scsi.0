Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5870C4724C
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA94E20857
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:46:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbgEARqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:46:49 -0400
Received: from verein.lst.de ([213.95.11.211]:48094 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729713AbgEARqt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 13:46:49 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id B27A868D12; Fri,  1 May 2020 19:46:47 +0200 (CEST)
Date:   Fri, 1 May 2020 19:46:47 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
Message-ID: <20200501174647.GD23795@lst.de>
References: <20200430131904.5847-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Can we get the basic infrastructure sorted out with just say csiostor
and virtio-scsi before we get into all the more complicated bits?
A 40+ series gets close to impossible to review unless it is just
all mechnical changes.
