Return-Path: <SRS0=GwgI=BR=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88D71C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 07:54:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FD7A22CAE
	for <linux-scsi@archiver.kernel.org>; Fri,  7 Aug 2020 07:54:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgHGHya (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 7 Aug 2020 03:54:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:40240 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbgHGHya (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 7 Aug 2020 03:54:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C638EAC4C;
        Fri,  7 Aug 2020 07:54:46 +0000 (UTC)
Date:   Fri, 7 Aug 2020 09:54:28 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Nilesh Javali <njavali@marvell.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v2 10/11] Revert "scsi: qla2xxx: Fix crash on
 qla2x00_mailbox_command"
Message-ID: <20200807075428.bzrhqwllvt5ajfhl@beryllium.lan>
References: <20200806111014.28434-1-njavali@marvell.com>
 <20200806111014.28434-11-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200806111014.28434-11-njavali@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 06, 2020 at 04:10:13AM -0700, Nilesh Javali wrote:
> FCoE adapter initialization failed for ISP8021.
> 
> This reverts commit 3cb182b3fa8b7a61f05c671525494697cba39c6a.

But wouldn't this revert not also bring back the crash from 3cb182b3fa8b
("scsi: qla2xxx: Fix crash on qla2x00_mailbox_command"):

    This patch fixes a crash on qla2x00_mailbox_command caused when the driver
    is on UNLOADING state and tries to call qla2x00_poll, which triggers a
    NULL pointer dereference.

