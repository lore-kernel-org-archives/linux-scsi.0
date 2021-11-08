Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57ADFC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 16:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F12F6125F
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 16:45:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241371AbhKHQsj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 11:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240167AbhKHQsi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Nov 2021 11:48:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EECEB6120A;
        Mon,  8 Nov 2021 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636389953;
        bh=l1vUPSTKlLkdU/pTPV1MbYUUsTvn0tPIgV83Bq2cIgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ptLe6DICWAyFRnCDtYQ3q4wY8aeGfXLrrU7MbpfTId2kvKVFNQ0Pr0XwusWxo/9Qv
         ctmPNmrTDQ1sNiKye/7/tuJNYJZwJdap3i8twtoaldaUTi78atqgOrPb2mmbsCF49x
         jqBs+yDU2Ami6te0bxCpYaCPUszj5CSgZyLrEnOHXzkvk/09JankI+g+rBdSOY61Gc
         QAdGG3vPtMc8nd2eaKjbwR2giXh3NFxa0gI1r7PXKpqVOKHvrLpgYJL6cj/eTttIfH
         sEOy5ojgy1o6v7Qp4laSPywc8Ut7YQ+kvar5gdaGt6GpREGnrjU6UHBLlKXYc2mTmm
         C157lRyDT5qTA==
Date:   Mon, 8 Nov 2021 08:45:50 -0800
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 4/4] nvme: wait until quiesce is done
Message-ID: <20211108164550.GB2660170@dhcp-10-100-145-180.wdc.com>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
 <20211103034305.3691555-5-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211103034305.3691555-5-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 03, 2021 at 11:43:05AM +0800, Ming Lei wrote:
> NVMe uses one atomic flag to check if quiesce is needed. If quiesce is
> started, the helper returns immediately. This way is wrong, since we
> have to wait until quiesce is done.

Looks good to me.

Reviewed-by: Keith Busch <kbusch@kernel.org>
