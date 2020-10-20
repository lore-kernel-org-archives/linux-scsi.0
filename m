Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08539C43457
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:01:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B75EA22244
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 07:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404735AbgJTHB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 03:01:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:44686 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404728AbgJTHB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 03:01:57 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BAFE5AEEE;
        Tue, 20 Oct 2020 07:01:56 +0000 (UTC)
Date:   Tue, 20 Oct 2020 09:01:56 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     James Smart <james.smart@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v4 01/31] elx: libefc_sli: SLI-4 register offsets and
 field definitions
Message-ID: <20201020070156.4r24jex75umo3jlo@beryllium.lan>
References: <20201012225147.54404-1-james.smart@broadcom.com>
 <20201012225147.54404-2-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201012225147.54404-2-james.smart@broadcom.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 12, 2020 at 03:51:17PM -0700, James Smart wrote:
> +#define SLI4_BMBX_WRITE_HI(r) \
> +	((upper_32_bits(r) & ~SLI4_BMBX_MASK_HI) | SLI4_BMBX_HI)
> +#define SLI4_BMBX_WRITE_LO(r) \
> +	(((upper_32_bits(r) & SLI4_BMBX_MASK_HI) << 30) | \
> +	 (((r) & ~SLI4_BMBX_MASK_LO) >> 2))

These could also be inline function. This would align it with the
rest of the file.

The rest looks good.

Reviewed-by: Daniel Wagner <dwagner@suse.de>
