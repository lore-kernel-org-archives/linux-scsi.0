Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23687C433FE
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 04:05:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0A5F22D75
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Dec 2020 04:05:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgLEEE6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 23:04:58 -0500
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:40580 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLEEE6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 23:04:58 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 0B1E02B60D;
        Fri,  4 Dec 2020 23:04:12 -0500 (EST)
Date:   Sat, 5 Dec 2020 15:04:18 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Hannes Reinecke <hare@suse.de>
cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 28/37] esp_scsi: use host byte as last argument to
 esp_cmd_is_done()
In-Reply-To: <20201204100140.140863-29-hare@suse.de>
Message-ID: <alpine.LNX.2.23.453.2012051503370.6@nippy.intranet>
References: <20201204100140.140863-1-hare@suse.de> <20201204100140.140863-29-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 4 Dec 2020, Hannes Reinecke wrote:

> Just pass in the host byte to esp_cmd_is_done(), and set the
> status or message bytes if the host byte is DID_OK.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Cc; Finn Thain <fthain@telegraphics.com.au>

Acked-by: Finn Thain <fthain@telegraphics.com.au>
