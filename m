Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC472C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9087761029
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 12:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhHQMOQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 08:14:16 -0400
Received: from verein.lst.de ([213.95.11.211]:58273 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236233AbhHQMOL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Aug 2021 08:14:11 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 06FBE67357; Tue, 17 Aug 2021 14:13:37 +0200 (CEST)
Date:   Tue, 17 Aug 2021 14:13:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH 02/51] lpfc: drop lpfc_no_handler()
Message-ID: <20210817121336.GB30436@lst.de>
References: <20210817091456.73342-1-hare@suse.de> <20210817091456.73342-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210817091456.73342-3-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
