Return-Path: <SRS0=lyXb=32=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EDBC2D0B1
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:21:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B07E121775
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Feb 2020 13:21:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgBFNV5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Feb 2020 08:21:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:43522 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726765AbgBFNV5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Feb 2020 08:21:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 08D93AE39;
        Thu,  6 Feb 2020 13:21:56 +0000 (UTC)
Message-ID: <bb273446a0f294e37dc0afb2c450fb761e345260.camel@suse.com>
Subject: Re: [PATCH 0/4] qla2xxx patches for kernel v5.6
From:   Martin Wilck <mwilck@suse.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, "dwagner@suse.de" <dwagner@suse.de>
Date:   Thu, 06 Feb 2020 14:23:22 +0100
In-Reply-To: <20191209180223.194959-1-bvanassche@acm.org>
References: <20191209180223.194959-1-bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.34.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart, hi Martin,

On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> Hi Martin,
> 
> Please consider these four small qla2xxx patches for kernel v5.6.
> 
> Thanks,
> 
> Bart.

it seems this series got lost somehow, including the point-to-point
mode fix?

I made some remarks back in December, but they were mostly nitpicks.
The only real issue with this set is that the last patch doesn't apply
cleanly.

Bart, could you resend?

Martin


