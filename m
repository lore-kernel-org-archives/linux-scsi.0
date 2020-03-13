Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA28FC10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 11:08:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 97EF8206E2
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 11:08:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgCMLIZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 07:08:25 -0400
Received: from verein.lst.de ([213.95.11.211]:41993 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgCMLIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 07:08:25 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3E78F68CEC; Fri, 13 Mar 2020 12:08:23 +0100 (CET)
Date:   Fri, 13 Mar 2020 12:08:23 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH v2 5/5] scsi/trace: Use get_unaligned_be24()
Message-ID: <20200313110823.GD8132@lst.de>
References: <20200313023718.21830-1-bvanassche@acm.org> <20200313023718.21830-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313023718.21830-6-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2020 at 07:37:18PM -0700, Bart Van Assche wrote:
> This makes the SCSI tracing code slightly easier to read.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
