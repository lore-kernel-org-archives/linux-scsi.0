Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B04C47253
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8C6C2173E
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 17:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbgEARtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 13:49:09 -0400
Received: from verein.lst.de ([213.95.11.211]:48109 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729572AbgEARtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 13:49:09 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BFAC568D37; Fri,  1 May 2020 19:49:07 +0200 (CEST)
Date:   Fri, 1 May 2020 19:49:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC v3 09/41] scsi: use real inquiry data when
 initialising devices
Message-ID: <20200501174907.GF23795@lst.de>
References: <20200430131904.5847-1-hare@suse.de> <20200430131904.5847-10-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430131904.5847-10-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 03:18:32PM +0200, Hannes Reinecke wrote:
> Use dummy inquiry data when initialising devices and not just
> a some string.

Why?    And what do the values mean?

