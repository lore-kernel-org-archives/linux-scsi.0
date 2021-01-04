Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E77C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28285216C4
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727529AbhADSNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:13:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:53580 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727030AbhADSNn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Jan 2021 13:13:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5875CACAF;
        Mon,  4 Jan 2021 18:13:02 +0000 (UTC)
Date:   Mon, 4 Jan 2021 19:13:02 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 30/31] elx: efct: Add Makefile and Kconfig for efct
 driver
Message-ID: <20210104181302.3o4rymriforghv5g@beryllium.lan>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-31-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210103171134.39878-31-jsmart2021@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 09:11:33AM -0800, James Smart wrote:
> This patch completes the efct driver population.
> 
> This patch adds driver definitions for:
> Adds the efct driver Kconfig and Makefiles
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Reviewed-by: Daniel Wagner <dwagner@suse.de>

