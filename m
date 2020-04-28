Return-Path: <SRS0=LQeo=6M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26FEC83001
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 00:25:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C05192072A
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Apr 2020 00:25:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726284AbgD1AZO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 20:25:14 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:39728 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbgD1AZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 20:25:14 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id AEF4E22B35;
        Mon, 27 Apr 2020 20:25:10 -0400 (EDT)
Date:   Tue, 28 Apr 2020 10:25:10 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     himanshu.madhani@oracle.com
cc:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: Re: [PATCH v4 10/11] qla2xxx: Fix endianness annotations in header
 files
In-Reply-To: <8ca5292e-88c6-ecb3-77b7-bd6735f5ccca@oracle.com>
Message-ID: <alpine.LNX.2.22.394.2004281017310.12@nippy.intranet>
References: <20200427030310.19687-1-bvanassche@acm.org> <20200427030310.19687-11-bvanassche@acm.org> <8ca5292e-88c6-ecb3-77b7-bd6735f5ccca@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 27 Apr 2020, himanshu.madhani@oracle.com wrote:

> 
> This looks okay, but i would strongly suggest driver maintainer to 
> verify if this introduces any regression or not.

If the changes don't affect code generation, regression is impossible. 

So, compilers (and cross-compilers) could answer your question, if they 
could achieve sufficient code coverage.

It would be nice if there was a tag that could be added to a patch so that 
CI services could check for compiler output invariance (.s or .i or both).

> 
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
