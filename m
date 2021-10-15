Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE46C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:16:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78F4F61090
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 16:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241142AbhJOQTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:19:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:51186 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236917AbhJOQTC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 12:19:02 -0400
Date:   Fri, 15 Oct 2021 18:16:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634314614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oqu1oJeEHUxhy202sz9OoMP/FwVFN/ikHYyAlVt7IQc=;
        b=kVqjNhvNFUOBXgfbiPZQKeKFnk0hFrIR/lZ67VOXMupRmg/tx4a1nSHDu2AEenlbTzwCVF
        +nkS7gp4RP7PruToCVjjMs6if3tH6pL6Mzfz4yygMGTE/M9ZVHQGHTpgo47BnNJb8E5AMJ
        qxeMyolajGXetDLmUfokPrnkksNeavDn/me97vZEtEa+hvuBqNq0zzQhBqEXVzbepPToKx
        0LJm2LpT+PvvowuPvJ/teMyvJijU+9qUj6CbNZ13FS9uVq12R/p6WjFkhVkfW7FlpQjM3S
        o5qYqv+LDlPUuAXFamkwTA/5k9OObiU+nhPW3+4ZcaNdrjp8+1QEvwWyoSJYQA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634314614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oqu1oJeEHUxhy202sz9OoMP/FwVFN/ikHYyAlVt7IQc=;
        b=TsfTdm4eLJJ3f45PPXWJBjp/6+Cv4ytxKVl99W2NkjFZTy9gEWPVnYqdOH/W8x+NZoBwCz
        RAvybNnPNKIineBg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org,
        usb-storage@lists.one-eyed-alien.net, Jens Axboe <axboe@kernel.dk>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/3] scsi, usb: storage: Complete the blk-request
 directly.
Message-ID: <20211015161653.muq37x6mkeru6lxc@linutronix.de>
References: <20211015151412.3229037-1-bigeasy@linutronix.de>
 <20211015151412.3229037-4-bigeasy@linutronix.de>
 <YWmmn4MpTSGHRVOU@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YWmmn4MpTSGHRVOU@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-10-15 09:04:47 [-0700], Christoph Hellwig wrote:
> Bart has been working on removing the ->scsi_done indirection, so this
> will need to find a way to interact with that

Okay. So I just wait until it is there. Is this v5.15/16 material?

Sebastian
