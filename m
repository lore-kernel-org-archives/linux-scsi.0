Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11B39C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Dec 2021 09:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhLVJGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 04:06:43 -0500
Received: from verein.lst.de ([213.95.11.211]:49809 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236355AbhLVJGn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 04:06:43 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4138F68AFE; Wed, 22 Dec 2021 10:06:40 +0100 (CET)
Date:   Wed, 22 Dec 2021 10:06:39 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, bhe@redhat.com
Subject: Re: [PATCH] sr: don't use GFP_DMA in get_capabilities
Message-ID: <20211222090639.GA25796@lst.de>
References: <20211222090159.916428-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222090159.916428-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sorry, I'll replace this with a v2 also covering the callsites in
sr_vendor.c.
