Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC16C32750
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 01:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F378020842
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 01:26:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfHNB0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 21:26:13 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43548 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfHNB0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 21:26:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2523320423A;
        Wed, 14 Aug 2019 03:26:11 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WsNyEZy6wk2y; Wed, 14 Aug 2019 03:26:04 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 90E2D20414F;
        Wed, 14 Aug 2019 03:26:03 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 09/20] sg: sg_allow_if_err_recovery and renames
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-10-dgilbert@interlog.com>
 <20190812143129.GB16127@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <969aaf52-6156-cae2-fcf2-5c5922f61828@interlog.com>
Date:   Tue, 13 Aug 2019 21:26:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812143129.GB16127@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:31 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:41PM +0200, Douglas Gilbert wrote:
>> Add sg_allow_if_err_recover() to do checks common to several entry
>> points. Replace retval with either res or ret. Rename
>> sg_finish_rem_req() to sg_finish_scsi_blk_rq(). Rename
>> sg_new_write() to sg_submit(). Other cleanups triggered by
>> checkpatch.pl .
> 
> I think you want to split adding a new helper from random renames.

"Random" is in the eye of the beholder. Take sg_new_write(), 20
years ago that referred to the newly introduced v3 interface. Its
a bit misleading to leave that name in place when the whole point
of the patchset is to add the v4 interface.

I don't understand why reviewers don't defer to a driver author and/or
maintainer in the cases of function and variable names. 20 years of
pigeonhole patches and kernel interface changes corrupt the original
naming and style of a driver. There are more significant things to
criticize if one looked deeper.

Doug Gilbert


