Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E412C43217
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 19:35:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiKATfd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 15:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKATfc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 15:35:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886891DDEE;
        Tue,  1 Nov 2022 12:35:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3ADEAB81F10;
        Tue,  1 Nov 2022 19:35:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A75CC433C1;
        Tue,  1 Nov 2022 19:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667331328;
        bh=lRcDTaMa+NMO1jJrmlNK7BqpoLcb0kk1Z/aOvAK1rsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBuDDwHVJ9WPwMF1C/RZG8ZAW9GbI9HT8iIFGJxT1LUjxKSfvKlXMTr7QTOBcNIKR
         zsRyE/5hQY2M065gFWGXsWgWB/kyeaxudMFuypHSmZWudQLTe75o7PwH6XbzQNBCQA
         7DJ2h1r0vwJTKRPgUGIjjTFEBgRHiLlrN8CapImU=
Date:   Tue, 1 Nov 2022 20:36:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, hare@suse.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH 5.10/5.15 v2] scsi: sd: Revert "scsi: sd: Remove a local
 variable"
Message-ID: <Y2F1N2s4z+EiDv5G@kroah.com>
References: <20221101013124.2615274-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101013124.2615274-1-yukuai1@huaweicloud.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 01, 2022 at 09:31:24AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> This reverts commit 84f7a9de0602704bbec774a6c7f7c8c4994bee9c.
> 
> Because it introduces a problem that rq->__data_len is set to the wrong
> value.

Now queued up, thanks.

greg k-h
