Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBF1C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 16:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B31422074D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 16:28:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgIDQ2x (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 12:28:53 -0400
Received: from smtp.infotech.no ([82.134.31.41]:56348 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725984AbgIDQ2x (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Sep 2020 12:28:53 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0FD0B20418E;
        Fri,  4 Sep 2020 18:28:48 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id BFbK9oqJSw7d; Fri,  4 Sep 2020 18:28:44 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 204BD204165;
        Fri,  4 Sep 2020 18:28:26 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: About BLKSECTGET in sg
To:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org
References: <CAGnHSEnhpaqcF8gWG9udrq_vwYWh2vOGL1VgN3=E=1OVjenVUQ@mail.gmail.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <bfd72561-08e9-88fc-8325-a9986d69d2fd@interlog.com>
Date:   Fri, 4 Sep 2020 12:28:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAGnHSEnhpaqcF8gWG9udrq_vwYWh2vOGL1VgN3=E=1OVjenVUQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-04 12:42 a.m., Tom Yan wrote:
> Hi,
> 
> Is BLKSECTGET in sg intentionally kept "broken" (i.e. it gives out
> max_sectors in bytes) or is it just a miss? I'm just wondering if I
> should send a patch to fix it (and implement BLKSSZGET).
> 
> Also, shouldn't max_sectors_bytes() in both drivers/scsi/sg.c and
> block/scsi_ioctl.c use queue_logical_block_size() instead?

Tom,
I have no idea! One of the great things about maintaining a driver in
Linux is that virtually anyone can send patches and get them accepted
without and Ack from the maintainer. And when bugs are found in those
patches, the culprits can't be found or have no inclination to fix them.

'git blame' will show you that I had nothing to do with the BLK*
ioctl()s added to the sg driver. That said, if they are broken, they
should be fixed. I would be interested in getting some test code as
I'm not familiar with using those ioctl()s.

Would you like to send some patches?

Doug Gilbert


