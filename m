Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7043FC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 07:40:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4A46054F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 07:40:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237267AbhHNHkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 14 Aug 2021 03:40:31 -0400
Received: from verein.lst.de ([213.95.11.211]:49498 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236519AbhHNHkb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 14 Aug 2021 03:40:31 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 503A668AFE; Sat, 14 Aug 2021 09:40:01 +0200 (CEST)
Date:   Sat, 14 Aug 2021 09:40:00 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     John Garry <john.garry@huawei.com>
Cc:     satishkh@cisco.com, sebaddel@cisco.com, kartilak@cisco.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de, hch@lst.de, bvanassche@acm.org
Subject: Re: [PATCH 0/3] Remove scsi_cmnd.tag
Message-ID: <20210814074000.GB21536@lst.de>
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The whole series looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
