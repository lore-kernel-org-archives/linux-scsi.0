Return-Path: <SRS0=OG9y=YO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 340E1CA9EB0
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 122172089C
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Oct 2019 23:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbfJUXUJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Oct 2019 19:20:09 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52602 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730146AbfJUXUI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Oct 2019 19:20:08 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id CECBF29E53;
        Mon, 21 Oct 2019 19:20:05 -0400 (EDT)
Date:   Tue, 22 Oct 2019 10:20:03 +1100 (AEDT)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Douglas Gilbert <dgilbert@interlog.com>
cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 00/24] scsi: Revamp result values
In-Reply-To: <8e07f2ba-cdef-6faa-559d-3beabc173edf@interlog.com>
Message-ID: <alpine.LNX.2.21.1910221017490.14@nippy.intranet>
References: <20191021095322.137969-1-hare@suse.de> <8e07f2ba-cdef-6faa-559d-3beabc173edf@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 21 Oct 2019, Douglas Gilbert wrote:

> 
> > As usual, comments and reviews are welcome.
> 
> It is hard to make an omelette without breaking some eggs.
> 

Coccinelle can minimize the breakage; particularly the 
straight-forward conversion of (FOO << 1) to SAM_STAT_BAR.

-- 

> Doug Gilbert
> 
