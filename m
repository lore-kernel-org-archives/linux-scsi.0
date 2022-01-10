Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA92FC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Jan 2022 22:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345086AbiAJWEv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jan 2022 17:04:51 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13754 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230413AbiAJWEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Jan 2022 17:04:51 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20AJlifl007280;
        Mon, 10 Jan 2022 22:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2021-07-09;
 bh=80AxMMgflWYL9WnVqJsX+/OLVsvGcU3CA3CW6uocWxw=;
 b=Hs6kPlqR9OOVtMbSZuhbaadZiw9u/Vk32WihEON6urPGsdibrY0xUZ7SeVxAFplqml6h
 Kf1t9oCSjVQclwI5rLG7PC1OcQ6J621YSKmPWANav+4GekjSS/oFGLvMZt/6QXoIfEoU
 GyrJSdj1exN+U5yPBMc92aUKCmWIg2K75DT1c1iCrh1R12YRkWD0OmJasQgdiT2LWLgg
 x99KtAkafLOIAHmuOnMVJ+HusxtUI6egSRBzil1mRP7+twU+qbAAx63QGqlp8nedez39
 hocNYOknsh/G0nJc/vdGmwDJboEU7LF13hWf5b0OTlndvIuc77ady5Tib09E+WDftvq6 uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3dgkhx1m9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:50 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 20ALtv9J138984;
        Mon, 10 Jan 2022 22:04:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 22:04:49 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 20AM4iC6174082;
        Mon, 10 Jan 2022 22:04:49 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3df2e3vqp8-5;
        Mon, 10 Jan 2022 22:04:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/2] small cleanups
Date:   Mon, 10 Jan 2022 17:04:37 -0500
Message-Id: <164182835584.13635.705551565621104447.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210929091744.706003-1-damien.lemoal@wdc.com>
References: <20210929091744.706003-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: d1Mk4IDUX1L7gJj1zzaDGVEiZFkhPp9y
X-Proofpoint-ORIG-GUID: d1Mk4IDUX1L7gJj1zzaDGVEiZFkhPp9y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 29 Sep 2021 18:17:42 +0900, Damien Le Moal wrote:

> Martin,
> 
> Here is a couple of patches ifor some light cleanup in scsi_lib.
> No functional changes are introduced.
> 
> Damien Le Moal (2):
>   scsi: simplify scsi_get_vpd_page()
>   scsi: fix scsi_mode_select() interface
> 
> [...]

Applied to 5.17/scsi-queue, thanks!

[2/2] scsi: fix scsi_mode_select() interface
      https://git.kernel.org/mkp/scsi/c/81d3f500ee98

-- 
Martin K. Petersen	Oracle Linux Engineering
