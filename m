Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D529C2BBFD
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4225620737
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 18:22:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XD5w0XjM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgDMSWu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 14:22:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:41728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387695AbgDMSWt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 14:22:49 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DIAhrG057732;
        Mon, 13 Apr 2020 18:22:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=d9rweeiKACYb4np+ASa2+QDpz4eFlzgf4GMZTwV2Hn0=;
 b=XD5w0XjMxhpdntlgLTKtVxcY54pjudt353DUfO9Vmek68E6eHp5uTBzFNbG/13l/M6Zw
 qPPhk8SeOp94kIL3fWGajEgrTaVsBRvbUsHoZW8Gz18v+3XH88rlXN+uc+5KRZml3dG+
 mR6vH34g32CeQQ7CYRbDbp2UioF7NNLuoiI5+wmhibsZlBJKqHvWxwZ0uXfodQGWn3mU
 WlYwefCneA0IWs4k0BUpAkaMdbnwFBJ+FkP6SXbeS+L1p43KFIcWVeRgQMIhg4r/HV2l
 cYGq0QRStkJxQCuf1g2yjRHIIZMF3ZYBZR8/dU+Da71U6zrvJvwzhN67acmXAcbu50hN BA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30b5ar05m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 18:22:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03DI84AL111325;
        Mon, 13 Apr 2020 18:20:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30bqpcu37v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Apr 2020 18:20:42 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03DIKfV7020077;
        Mon, 13 Apr 2020 18:20:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 11:20:41 -0700
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 23/35] docs: fusion: mptbase.c: get rid of a doc build warning
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <cover.1586359676.git.mchehab+huawei@kernel.org>
        <9ca049c2d25689c56448afddf4f0d1e619fa87f7.1586359676.git.mchehab+huawei@kernel.org>
Date:   Mon, 13 Apr 2020 14:20:38 -0400
In-Reply-To: <9ca049c2d25689c56448afddf4f0d1e619fa87f7.1586359676.git.mchehab+huawei@kernel.org>
        (Mauro Carvalho Chehab's message of "Wed, 8 Apr 2020 17:46:15 +0200")
Message-ID: <yq17dyjxn61.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=996 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004130139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 impostorscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004130139
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Mauro,

> Use a table for the enum list, to avoid this warning:
>
> 	./drivers/message/fusion/mptbase.c:5058: WARNING: Definition list ends without a blank line; unexpected unindent.

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
