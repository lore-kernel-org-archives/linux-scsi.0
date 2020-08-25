Return-Path: <SRS0=BOoC=CD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01B7C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 07:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84FF92078A
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Aug 2020 07:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgHYHGa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Aug 2020 03:06:30 -0400
Received: from smtprelay0045.hostedemail.com ([216.40.44.45]:38566 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729137AbgHYHG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Aug 2020 03:06:29 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id A520D100E7B43;
        Tue, 25 Aug 2020 07:06:28 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: tooth00_0809ad927059
X-Filterd-Recvd-Size: 2084
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Tue, 25 Aug 2020 07:06:27 +0000 (UTC)
Message-ID: <dc8aca7e3772670782c2abc086cab8b6f81be3c1.camel@perches.com>
Subject: Re: [PATCH] scsi: megaraid: Remove unnecessary assignment to
 variable ret
From:   Joe Perches <joe@perches.com>
To:     Jing Xiangfeng <jingxiangfeng@huawei.com>,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 25 Aug 2020 00:06:26 -0700
In-Reply-To: <5e8d3765063043f7a90c92c098317319757595ed.camel@perches.com>
References: <20200825063836.92239-1-jingxiangfeng@huawei.com>
         <5e8d3765063043f7a90c92c098317319757595ed.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-08-25 at 00:01 -0700, Joe Perches wrote:
> On Tue, 2020-08-25 at 14:38 +0800, Jing Xiangfeng wrote:
> > The variable ret is being initialized with 'FAILED'. So we can remove
> > this assignement.
> 
> If you are going to change the code at all,
> might as well try to improve it more by removing
> the unnecessary out: label altogether.

Looks like the megaraid mailing list is either subscribers-only
or doesn't exist anymore as my mail to it bounced.

One of the maintainers should remove it or update it.

Maybe:
---
diff --git a/MAINTAINERS b/MAINTAINERS
index ac79fdbdf8d0..0c181cd07201 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11060,7 +11060,7 @@ MEGARAID SCSI/SAS DRIVERS
 M:	Kashyap Desai <kashyap.desai@broadcom.com>
 M:	Sumit Saxena <sumit.saxena@broadcom.com>
 M:	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
-L:	megaraidlinux.pdl@broadcom.com
+L:	megaraidlinux.pdl@broadcom.com (subscribers-only)
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 W:	http://www.avagotech.com/support/


