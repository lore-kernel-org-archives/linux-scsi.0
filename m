Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71865C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 08:56:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1944723138
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 08:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729531AbhASI4E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 03:56:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:53938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730749AbhASIzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Jan 2021 03:55:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4F03CB815;
        Tue, 19 Jan 2021 08:55:04 +0000 (UTC)
Date:   Tue, 19 Jan 2021 09:55:03 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Arun Easi <aeasi@marvell.com>, Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH] scsi: qla2xxx: fix description for parameter
 ql2xenforce_iocb_limit
Message-ID: <20210119085503.wrc3ujjhj7a2kfhs@beryllium.lan>
References: <20210118184922.23793-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210118184922.23793-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 18, 2021 at 03:49:22PM -0300, Enzo Matsumiya wrote:
> Parameter ql2xenforce_iocb_limit is enabled by default.
> 
> Fixes: 89c72f4245a8 ("scsi: qla2xxx: Add IOCB resource tracking")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

