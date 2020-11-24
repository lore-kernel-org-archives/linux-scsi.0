Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5080C64E69
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6774720870
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Nov 2020 04:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbgKXEdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Nov 2020 23:33:19 -0500
Received: from smtprelay0150.hostedemail.com ([216.40.44.150]:53014 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728828AbgKXEdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Nov 2020 23:33:19 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id C1265837F24A;
        Tue, 24 Nov 2020 04:33:17 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: bread73_1a0b27a2736b
X-Filterd-Recvd-Size: 1221
Received: from XPS-9350.home (unknown [47.151.128.180])
        (Authenticated sender: joe@perches.com)
        by omf06.hostedemail.com (Postfix) with ESMTPA;
        Tue, 24 Nov 2020 04:33:16 +0000 (UTC)
Message-ID: <3b5f1d63666a1cf70143574f75cfb0d7f5d0e0de.camel@perches.com>
Subject: Re: [PATCH 0/2] scsi: pm8001: logging neatening
From:   Joe Perches <joe@perches.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-kernel@vger.kernel.org
Date:   Mon, 23 Nov 2020 20:33:15 -0800
In-Reply-To: <yq1r1ojmoa5.fsf@ca-mkp.ca.oracle.com>
References: <cover.1605914030.git.joe@perches.com>
         <yq1r1ojmoa5.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-11-23 at 22:23 -0500, Martin K. Petersen wrote:
> > Reduce code duplication and generic neatening of logging macros
> 
> Applied to 5.11/scsi-staging, thanks!

Thanks.

The kernel robot reported an indentation defect here so I will send
a couple more patches on top of this.


