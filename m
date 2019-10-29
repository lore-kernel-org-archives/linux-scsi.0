Return-Path: <SRS0=POaH=YW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD0A7CA9EC0
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 01:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0AF21835
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Oct 2019 01:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728821AbfJ2BxY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 21:53:24 -0400
Received: from mellowmood.mkp.net ([104.200.29.94]:59880 "EHLO
        mellowmood.mkp.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728432AbfJ2BxY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 21:53:24 -0400
Received: from mellowmood.mkp.net (localhost [127.0.0.1])
        by mellowmood.mkp.net (Postfix) with ESMTP id 78809BB2;
        Mon, 28 Oct 2019 21:53:22 -0400 (EDT)
To:     Saurav Girepunje <saurav.girepunje@gmail.com>
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        saurav.girepunje@hotmail.com, saurav.girepunje@gmail.com
Subject: Re: [PATCH] scsi: lpfc: Fix NULL check before mempool_destroy is not needed
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191026194712.GA22249@saurav>
Date:   Mon, 28 Oct 2019 21:53:22 -0400
In-Reply-To: <20191026194712.GA22249@saurav> (Saurav Girepunje's message of
        "Sun, 27 Oct 2019 01:17:17 +0530")
Message-ID: <yq1lft48gh9.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Saurav,

> mempool_destroy has taken null pointer check into account.  so remove
> the redundant check.

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
