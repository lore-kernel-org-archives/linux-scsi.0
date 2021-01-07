Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D33C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 08:53:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 401692333D
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 08:53:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbhAGIxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 03:53:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:50028 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbhAGIxz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 03:53:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 65181AD1E;
        Thu,  7 Jan 2021 08:53:14 +0000 (UTC)
Date:   Thu, 7 Jan 2021 09:53:14 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v6 15/31] elx: libefc: Extended link Service IO handling
Message-ID: <20210107085314.qllsvb6wjmr2xjzp@beryllium.lan>
References: <20210107005030.2929-1-jsmart2021@gmail.com>
 <20210107005030.2929-16-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107005030.2929-16-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 06, 2021 at 04:50:14PM -0800, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> Functions to build and send ELS/CT/BLS commands and responses.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v6:
>  efc_disc_io_complete(): update WARN_ON to WARN_ON_ONCE
>  Change els send functions to return status from efc_els_send_req()

Wouldn't it make sense to do the same for efc_els_send_rsp()?

