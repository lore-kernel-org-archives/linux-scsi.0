Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87DAAC433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 08:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25665206D5
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 08:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388362AbgJTITd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 04:19:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:59538 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388222AbgJTITd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 04:19:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62A5EAC6D;
        Tue, 20 Oct 2020 08:19:32 +0000 (UTC)
Date:   Tue, 20 Oct 2020 10:19:31 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v4 08/31] elx: libefc: Generic state machine framework
Message-ID: <20201020081931.ko6lwdge3v2o6avh@beryllium.lan>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-9-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012225147.54404-9-james.smart@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 12, 2020 at 03:51:24PM -0700, James Smart wrote:
> This patch starts the population of the libefc library.
> The library will contain common tasks usable by a target or initiator
> driver. The library will also contain a FC discovery state machine
> interface.
> 
> This patch creates the library directory and adds definitions
> for the discovery state machine interface.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <james.smart@broadcom.com>

Looks good to me.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
