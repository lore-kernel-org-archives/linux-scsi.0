Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE95AC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 11:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B537C2177B
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 11:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728902AbgH0LrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 07:47:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:54476 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728831AbgH0Lqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 07:46:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 68A62AFFB;
        Thu, 27 Aug 2020 11:46:59 +0000 (UTC)
Date:   Thu, 27 Aug 2020 13:46:26 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Martin Wilck <mwilck@suse.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH 4/4] qla2xxx: Handle incorrect entry_type entries
Message-ID: <20200827114626.daispydkcsdp3rj2@beryllium.lan>
References: <20200827095829.63871-1-dwagner@suse.de>
 <20200827095829.63871-5-dwagner@suse.de>
 <21cd86f782616fcac25f1a6270a9bd834ec777b7.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21cd86f782616fcac25f1a6270a9bd834ec777b7.camel@suse.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Aug 27, 2020 at 12:17:13PM +0200, Martin Wilck wrote:
> Should we perhaps log an error message when we detect a mismatch
> between sp->type and entry_type?

Sure can do, but does it really help? Not much we can do in the
driver. I hope the firmware gets fixed eventually. I am not against it,
just not sure if the log entry really is helping except saying 'you are
using a firmware with a known issue'.
