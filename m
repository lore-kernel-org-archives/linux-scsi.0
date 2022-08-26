Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3A9ECAAD6
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Aug 2022 10:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbiHZKwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Aug 2022 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343723AbiHZKwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2022 06:52:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967D7C59D5;
        Fri, 26 Aug 2022 03:52:06 -0700 (PDT)
Date:   Fri, 26 Aug 2022 12:52:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1661511125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AcBhOUfjCU0/EpkwIrVCvmsXvHvFxYrl5N/njRsUdYc=;
        b=ScOCwBbVqwD1I7R7PWDqWaPibViOyq/x5Nzh7T0FlAl614JW3V1Sx0Gq5WnS2J6Fz13ho7
        wdAb5BRMM+iWoLcjxAkMCLmvRYSoCtMP4WTbWrQBMcIuFWGnpH2E2qnfofUIApc/OO7ra3
        jaHk6/uG6N+RZ3z2lIXHVse1Wo0U3zAsy2llj0QSjVJSSJ//Q36aUanToUJ2TdyCi73JEk
        Qy7SgejFtKNSlO9lfilUUW7tfwwc9EB7c/aUszrmH+/D3hocxbFU37xNh9BeTv85rYiIWH
        DeNcR0h3sbp0Khs7Oc4ydrUF4qXaDx3pMvIsOBAZoRs5LEHiTiiNldb2IB5QLw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1661511125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AcBhOUfjCU0/EpkwIrVCvmsXvHvFxYrl5N/njRsUdYc=;
        b=bWKqx4HnixDXaaYz3oju6CqNuhoyWH15Q++CzHTNkvS7tR/lPlG+bGohFhelKvt9BPIE9p
        w//by8Fhf3jRPyBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc:     Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Youn <John.Youn@synopsys.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 00/25] usb: gadget: f_tcm: Enhance UASP driver
Message-ID: <Ywil0y5I/oXjPJp9@linutronix.de>
References: <cover.1658192351.git.Thinh.Nguyen@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1658192351.git.Thinh.Nguyen@synopsys.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-07-18 18:26:01 [-0700], Thinh Nguyen wrote:
> The Linux UASP gadget driver is incomplete and remained broken for a long time.
> It was not implemented for performance either. This series adds some of the
> required features for the UASP driver to work. It also makes some changes to
> the target core.

Some patches here have fixes: tags and are in the middle of the series.
If they are indeed fixes which are needed for the driver function
regardless of the other changes, which are part of the series, then they
should be moved to the front of series _or_ submitted independently as
in "lets first fix the broken things and then make it pretty".

All in all I am happy to see that somebody is looking into the target
USB gadget.

Sebastian
