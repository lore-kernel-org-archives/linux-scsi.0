Return-Path: <SRS0=/G9W=WJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B9FFC433FF
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 00:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD5722067D
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Aug 2019 00:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfHMAfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 20:35:15 -0400
Received: from smtp.infotech.no ([82.134.31.41]:39181 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbfHMAfP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Aug 2019 20:35:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 216EC2041D7;
        Tue, 13 Aug 2019 02:35:14 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id J0FRvjbGiMTA; Tue, 13 Aug 2019 02:35:12 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id C1C56204150;
        Tue, 13 Aug 2019 02:35:11 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 04/20] sg: rework sg_poll(), minor changes
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-5-dgilbert@interlog.com>
 <20190812142312.GD8105@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <52330743-f99e-a3a6-d840-4ea111ad29d8@interlog.com>
Date:   Mon, 12 Aug 2019 20:35:10 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812142312.GD8105@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:23 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:36PM +0200, Douglas Gilbert wrote:
>> Re-arrange code in sg_poll(). Rename sg_read_oxfer() to
>> sg_rd_append(). In sg_start_req() rename rw to r0w.
>> Plus associated changes demanded by checkpatch.pl
> 
> r0w seems like a really odd variably name that doesn't help
> readability.  Also all these changes seem independent from each
> other to me, so they should be split into multiple patches.

When I see a bool called "rw" I wonder whether true means write
or read. When I see a bool called "r0w" then I would guess
false means read. Maybe it's just me ...

Doug Gilbert

