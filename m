Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC716C2BA1A
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 06:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 906E42168B
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 06:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgDXGrd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 02:47:33 -0400
Received: from verein.lst.de ([213.95.11.211]:33407 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726051AbgDXGrd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 02:47:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id ADDEB68CEC; Fri, 24 Apr 2020 08:47:29 +0200 (CEST)
Date:   Fri, 24 Apr 2020 08:47:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        Dexuan Cui <decui@microsoft.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH V2] scsi: avoid to run synchronize_rcu for each device
 in scsi_host_block
Message-ID: <20200424064729.GA23754@lst.de>
References: <20200423020713.332743-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423020713.332743-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
