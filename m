Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF26C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 09:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E134D22B2E
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 09:08:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727721AbhAHJIJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jan 2021 04:08:09 -0500
Received: from mx2.suse.de ([195.135.220.15]:41230 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbhAHJIE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Jan 2021 04:08:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0615EACC6;
        Fri,  8 Jan 2021 09:07:23 +0000 (UTC)
Date:   Fri, 8 Jan 2021 10:07:22 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v7 15/31] elx: libefc: Extended link Service IO handling
Message-ID: <20210108090722.lnmcoufwuwxjvwsc@beryllium.lan>
References: <20210107225905.18186-1-jsmart2021@gmail.com>
 <20210107225905.18186-16-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107225905.18186-16-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jan 07, 2021 at 02:58:49PM -0800, James Smart wrote:
> This patch continues the libefc library population.
> 
> This patch adds library interface definitions for:
> Functions to build and send ELS/CT/BLS commands and responses.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>

Reviewed-by: Daniel Wagner <dwagner@suse.de>
