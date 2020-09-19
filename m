Return-Path: <SRS0=lXoO=C4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6085C43464
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 07:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B04E921D42
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Sep 2020 07:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgISHnJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Sep 2020 03:43:09 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:35242 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgISHnJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Sep 2020 03:43:09 -0400
X-Greylist: delayed 392 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2020 03:43:09 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 04B492243C;
        Sat, 19 Sep 2020 03:36:35 -0400 (EDT)
Date:   Sat, 19 Sep 2020 17:36:32 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>
cc:     schmitzmic@gmail.com, linux@armlinux.org.uk, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: remove redundant initialization of variable ret
In-Reply-To: <20200918090747.44645-1-jingxiangfeng@huawei.com>
Message-ID: <alpine.LNX.2.23.453.2009191729360.9@nippy.intranet>
References: <20200918090747.44645-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 18 Sep 2020, Jing Xiangfeng wrote:

> The variable ret is being initialized with '-ENOMEM' that is
> meaningless. So remove it.
> 

Acked-by: Finn Thain <fthain@telegraphics.com.au>
