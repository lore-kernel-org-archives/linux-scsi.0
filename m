Return-Path: <SRS0=tG2Y=X5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D741AC47404
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 06:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B751B20862
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Oct 2019 06:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388146AbfJDGKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Oct 2019 02:10:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:45748 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387618AbfJDGKP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 4 Oct 2019 02:10:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6438AF85;
        Fri,  4 Oct 2019 06:10:13 +0000 (UTC)
Message-ID: <ccb8df9b0c0138b901c5d137a68960e6f024da8f.camel@suse.de>
Subject: Re: [PATCH] qla2xxx: fix a potential NULL pointer dereference
From:   Martin Wilck <mwilck@suse.de>
To:     Allen Pais <allen.pais@oracle.com>, martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Date:   Fri, 04 Oct 2019 08:10:20 +0200
In-Reply-To: <1568824618-4366-1-git-send-email-allen.pais@oracle.com>
References: <1568824618-4366-1-git-send-email-allen.pais@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2019-09-18 at 22:06 +0530, Allen Pais wrote:
> alloc_workqueue is not checked for errors and as a result,
> a potential NULL dereference could occur.
> 
> Signed-off-by: Allen Pais <allen.pais@oracle.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c | 4 ++++
>  1 file changed, 4 insertions(+)

Reviewed-by: Martin Wilck <mwilck@suse.com>


