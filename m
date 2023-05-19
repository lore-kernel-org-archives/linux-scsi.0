Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1004EC77B7A
	for <linux-scsi@archiver.kernel.org>; Fri, 19 May 2023 18:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjESS5H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 May 2023 14:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjESS5G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2023 14:57:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC0DF3;
        Fri, 19 May 2023 11:57:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA22D60C6D;
        Fri, 19 May 2023 18:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A7FC433EF;
        Fri, 19 May 2023 18:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684522625;
        bh=zgl1VYrPHEXkov2mLb5707vPjUUXD/GbC4EK49xZdz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ek8PTlpqngPumGqdWnS1jkCmAp7WkhH8NaugLwTeJ7GvwBB8qEwtYweZhCcV8KzAR
         ckID5lq3wS9765zahn1nzbXy57OYUE7dPClG+W+htqrPxK2ynbLhCfuw9R3DG0JqsN
         7Y8vHRz4gxZKMI+mKT/vYzmn1g4FvmJM7hq5A1BFB/EuVRAVcmQtd6ITP71VUYp3Xv
         XY3ioajindvG+h8cX/FSIWesuZwLixUDelbhac7iCSxUroH7K+gXuont8A0LyMRCnj
         sVoF5t6vGsHk5Mvna9xhA+4McfBciXuayEKT4bZ2kYaEVJMzyE6cEZf58zaS/3ICL3
         r4n2Ak1dpO88Q==
Date:   Fri, 19 May 2023 18:57:03 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?utf-8?B?6IyD5L+K5p2w?= <junjie2020@iscas.ac.cn>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in do_epoll_create
Message-ID: <20230519185703.GA3288616@google.com>
References: <eb5a09c.67fa.1883321b285.Coremail.junjie2020@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb5a09c.67fa.1883321b285.Coremail.junjie2020@iscas.ac.cn>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, May 19, 2023 at 04:30:26PM +0800, 范俊杰 wrote:
> Hi Kernel maintainers,
> 
> Our tool found a new bug memory leak in do_epoll_create in Kernel commit
> v5.14.
> 

v5.14 is almost 2 years old.  Why are you testing such an old kernel version?
This bug could have already been fixed almost 2 years ago.

Also, if you think this is a bug in eventpoll, this report should be sent to
linux-fsdevel, as per './scripts/get_maintainer.pl fs/eventpoll.c'.  It's
unclear why you are sending this report to linux-scsi.

> The report is as below and this bug don't have a repro C program until
> now. Please inform me if you confirm this is a reproducible bug.

I think you answered your own question.  It doesn't have a reproducer;
therefore, it's not reproducible.

- Eric
