Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B781AC433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 15:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83ACC64F13
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 15:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhBKPY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 10:24:28 -0500
Received: from verein.lst.de ([213.95.11.211]:55807 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229850AbhBKPWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:14 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 60B9D6736F; Thu, 11 Feb 2021 16:09:44 +0100 (CET)
Date:   Thu, 11 Feb 2021 16:09:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Subject: Re: [PATCH 02/14] target: drop kref_get_unless_zero in
 target_get_sess_cmd
Message-ID: <20210211150944.GA22082@lst.de>
References: <20210211122728.31721-1-michael.christie@oracle.com> <20210211122728.31721-3-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211122728.31721-3-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
