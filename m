Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C07A5C54EBC
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Jan 2023 20:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjAGUOE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Jan 2023 15:14:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjAGUOC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Jan 2023 15:14:02 -0500
Received: from msg-1.mailo.com (msg-1.mailo.com [213.182.54.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EF9C757;
        Sat,  7 Jan 2023 12:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mailo.com; s=mailo;
        t=1673122432; bh=HH2eHEZl+y1J6jyFsw9Q2SOJYnKKPuwBJha+gp4jMQ0=;
        h=X-EA-Auth:Date:From:To:Cc:Subject:Message-ID:References:
         MIME-Version:Content-Type:In-Reply-To;
        b=mVJXLZ0lmxF42piqDigDJ7sT4KMkjheq7qi2x/2WdCpQ0d/Nn5AZiQgwPnG/ZMsgf
         8FX9uVlNjmUgqoW82cDztUYMVM3jCBPdXiN3OlBfcQqh8+Xki10DlsCpGHJK/h1vzM
         YBk/Js7kcCAx56OWmGW9QQ2jlgE7hQ4mRHW5lmbE=
Received: by b-3.in.mailobj.net [192.168.90.13] with ESMTP
        via ip-206.mailobj.net [213.182.55.206]
        Sat,  7 Jan 2023 21:13:52 +0100 (CET)
X-EA-Auth: f8+D3POIM0XIqxl0YFEXEeqrBSqzRYP54X7B2nIiew85XgmFGfAKu6vONn6S+H4kXL3dVGALL9yErZamsD/QHyTYkOMaoWOu
Date:   Sun, 8 Jan 2023 01:43:43 +0530
From:   Deepak R Varma <drv@mailo.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Saurabh Singh Sengar <ssengar@microsoft.com>,
        Praveen Kumar <kumarpraveen@linux.microsoft.com>,
        Deepak R Varma <drv@mailo.com>
Subject: Re: [PATCH] scsi: aic94xx: Use sysfs_emit in show function callsbacks
Message-ID: <Y7nSd3MYaXr9llSa@ubun2204.myguest.virtualbox.org>
References: <Y6XqSnPb/y/GMTiX@qemulion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6XqSnPb/y/GMTiX@qemulion>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Dec 23, 2022 at 11:20:02PM +0530, Deepak R Varma wrote:
> According to Documentation/filesystems/sysfs.rst, the show() callback
> function of kobject attributes should strictly use sysfs_emit instead
> of sprintf family functions.
> Issue identified using the coccinelle device_attr_show.cocci script.
>
> Signed-off-by: Deepak R Varma <drv@mailo.com>
> ---

Hello,
Requesting a review and feedback on this patch proposal. There are a few other
similar patches for other scsi drivers that also need your comments. Request to
also review those.

Thank you,
./drv



