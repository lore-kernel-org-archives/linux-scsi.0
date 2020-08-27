Return-Path: <SRS0=qcVN=CF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63EEC433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 12:48:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D01F122CAE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Aug 2020 12:48:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgH0MqS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Aug 2020 08:46:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:60942 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728847AbgH0Mpv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 27 Aug 2020 08:45:51 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 27660B65C;
        Thu, 27 Aug 2020 12:46:22 +0000 (UTC)
Message-ID: <1f16a16669dd78127236db1916e41387ebdd32d1.camel@suse.com>
Subject: Re: [PATCH 4/4] qla2xxx: Handle incorrect entry_type entries
From:   Martin Wilck <mwilck@suse.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nilesh Javali <njavali@marvell.com>
Date:   Thu, 27 Aug 2020 14:45:49 +0200
In-Reply-To: <20200827114626.daispydkcsdp3rj2@beryllium.lan>
References: <20200827095829.63871-1-dwagner@suse.de>
         <20200827095829.63871-5-dwagner@suse.de>
         <21cd86f782616fcac25f1a6270a9bd834ec777b7.camel@suse.com>
         <20200827114626.daispydkcsdp3rj2@beryllium.lan>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-08-27 at 13:46 +0200, Daniel Wagner wrote:
> On Thu, Aug 27, 2020 at 12:17:13PM +0200, Martin Wilck wrote:
> > Should we perhaps log an error message when we detect a mismatch
> > between sp->type and entry_type?
> 
> Sure can do, but does it really help? Not much we can do in the
> driver. I hope the firmware gets fixed eventually. I am not against
> it,
> just not sure if the log entry really is helping except saying 'you
> are
> using a firmware with a known issue'.
> 

... which might provide insightful, to users as well as perhaps
developers (by observing under which conditions this problem occurs).
I'd hope so, at least. But you know this issue much better than me.

Regards,
Martin


