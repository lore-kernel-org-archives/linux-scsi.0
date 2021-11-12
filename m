Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0987C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 00:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71D9B61381
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Nov 2021 00:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhKLAVR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Nov 2021 19:21:17 -0500
Received: from vps.thesusis.net ([34.202.238.73]:46486 "EHLO vps.thesusis.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229862AbhKLAVR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Nov 2021 19:21:17 -0500
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2021 19:21:16 EST
Received: by vps.thesusis.net (Postfix, from userid 1000)
        id BE862659C0; Thu, 11 Nov 2021 19:12:09 -0500 (EST)
References: <20211105064623.GD32560@hostway.ca>
 <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
 <20211107022410.GA6530@hostway.ca>
 <ce4f925f-cbf9-9bbb-4bde-dd57059e3c84@acm.org>
 <20211111010106.GA27431@hostway.ca>
 <67af6917-653c-28a9-368a-db9599620bfa@suse.de>
User-agent: mu4e 1.7.0; emacs 27.1
From:   Phillip Susi <phill@thesusis.net>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Simon Kirby <sim@hostway.ca>, Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: Unreliable disk detection order in 5.x
Date:   Thu, 11 Nov 2021 19:11:19 -0500
In-reply-to: <67af6917-653c-28a9-368a-db9599620bfa@suse.de>
Message-ID: <87pmr65j1i.fsf@vps.thesusis.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hannes Reinecke <hare@suse.de> writes:

> Why is by-uuid not available?
> The uuid is the disk-internal unique identification, and to my
> knowledge all recent SCSI and SATA drives implement them.
> So where is the problem here?

It is probably just an oversight by the udev rules that create the
by-uuid links.
