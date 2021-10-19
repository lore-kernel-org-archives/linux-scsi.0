Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CFF0C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 21:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662D361156
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Oct 2021 21:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232726AbhJSVGj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Oct 2021 17:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhJSVGh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Oct 2021 17:06:37 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A61C06161C;
        Tue, 19 Oct 2021 14:04:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 3F7BF7DE;
        Tue, 19 Oct 2021 21:04:22 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 3F7BF7DE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1634677462; bh=OBcS/ydQa8jx7fNfnnJNWUzruUCNqteSSCGMNGtXBQk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Air9jU1ddzD3XVn+ET5DV9x7i7OrWZN/DVwJuDI40ThC9obz0SBdkjOu5v3ED5Aql
         cDw9YwdQ1+rjiFMHx+X9TDbqFr0CO8srUhKVmtpMZVB/jZjFf1yGdHQrtishdmziom
         cFGB0ipeBza8mEAKWs2cQybPK60p4bAuYJvibSJ2haNPmlOQKUqDMdSjcqRA3mIHX/
         ww4dy/PVMrBeMhtNcK7JeH3NtNkssHRA7q8Djycas+WVy1MiyCTysVulp5PjWd/gBG
         iaLkP5VTXNTRueNPGPUiv2mJL6uv3DQqameEnDea84a5jjIHcnSxwD4yeHxOqVBSY6
         bv4EoLj9O4lDg==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Jens Axboe <axboe@kernel.dk>, Steffen Maier <maier@linux.ibm.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH] block: add documentation for inflight
In-Reply-To: <572fd6c4-ccb9-4799-3882-685efa4492ad@kernel.dk>
References: <20211019130230.77594-1-maier@linux.ibm.com>
 <572fd6c4-ccb9-4799-3882-685efa4492ad@kernel.dk>
Date:   Tue, 19 Oct 2021 15:04:21 -0600
Message-ID: <87lf2osp4a.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Jens Axboe <axboe@kernel.dk> writes:

> On 10/19/21 7:02 AM, Steffen Maier wrote:
>> Complements v2.6.32 commit a9327cac440b ("Seperate read and write
>> statistics of in_flight requests") and commit 316d315bffa4 ("block:
>> Seperate read and write statistics of in_flight requests v2").
>
> Jon, probably better if you take this through the doc tree. You can
> add my:
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>

Done.

Thanks,

jon
