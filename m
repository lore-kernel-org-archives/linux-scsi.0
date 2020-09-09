Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88263C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 04:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57DBD21D20
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 04:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgIIEKk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Sep 2020 00:10:40 -0400
Received: from smtprelay0171.hostedemail.com ([216.40.44.171]:34126 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725300AbgIIEKk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Sep 2020 00:10:40 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 0A2AF180A7FEE;
        Wed,  9 Sep 2020 04:10:39 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: cars41_4c07f83270da
X-Filterd-Recvd-Size: 2198
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Wed,  9 Sep 2020 04:10:37 +0000 (UTC)
Message-ID: <0998cf5c4006b974b65ece9df1e782b840ff43cf.camel@perches.com>
Subject: Re: [PATCH 0/2] scsi: lpfc: Reduce logging object code size
From:   Joe Perches <joe@perches.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 08 Sep 2020 21:10:36 -0700
In-Reply-To: <cover.1597100152.git.joe@perches.com>
References: <cover.1597100152.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-08-10 at 15:59 -0700, Joe Perches wrote:
> The logging macros are pretty heavyweight and can be consolidated
> to reduce overall object size.
> 
> Joe Perches (2):
>   scsi: lpfc: Neaten logging macro #defines
>   scsi: lpfc: Add logging functions to reduce object size
> 
>  drivers/scsi/lpfc/Makefile       |   2 +-
>  drivers/scsi/lpfc/lpfc.h         |   5 ++
>  drivers/scsi/lpfc/lpfc_attr.h    |   5 ++
>  drivers/scsi/lpfc/lpfc_bsg.h     |   6 ++
>  drivers/scsi/lpfc/lpfc_compat.h  |   5 ++
>  drivers/scsi/lpfc/lpfc_crtn.h    |   5 ++
>  drivers/scsi/lpfc/lpfc_disc.h    |   5 ++
>  drivers/scsi/lpfc/lpfc_hw.h      |   5 ++
>  drivers/scsi/lpfc/lpfc_hw4.h     |   5 ++
>  drivers/scsi/lpfc/lpfc_ids.h     |   5 ++
>  drivers/scsi/lpfc/lpfc_logmsg.c  | 112 +++++++++++++++++++++++++++++++
>  drivers/scsi/lpfc/lpfc_logmsg.h  |  63 ++++++-----------
>  drivers/scsi/lpfc/lpfc_nl.h      |   4 ++
>  drivers/scsi/lpfc/lpfc_nvme.h    |   5 ++
>  drivers/scsi/lpfc/lpfc_scsi.h    |   4 ++
>  drivers/scsi/lpfc/lpfc_sli.h     |   5 ++
>  drivers/scsi/lpfc/lpfc_sli4.h    |   5 ++
>  drivers/scsi/lpfc/lpfc_version.h |   5 ++
>  18 files changed, 208 insertions(+), 43 deletions(-)
>  create mode 100644 drivers/scsi/lpfc/lpfc_logmsg.c

ping?


