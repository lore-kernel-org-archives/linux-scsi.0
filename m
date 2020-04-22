Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2597BC38A30
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 049B1206EC
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 04:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="toMAIth/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgDVEL2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:11:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40030 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgDVEL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 00:11:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M48PF0146397;
        Wed, 22 Apr 2020 04:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=LJPIxEjvAyJWR1bKqIIXFUCN6Ey7++feqURLD0U6oLI=;
 b=toMAIth/pZ777CW06WY28Ymy/PFJDn70Ouu6E35/v1vbIGYXkezRh78f6jM4AYPwrRpt
 JhvMsmaF78pZfTvL4phl/zfVdrOEut1UjUQns3qJ/bs06BmKzKS47KwIYYU728WrS4NU
 iuF0uRCq2I1Lduc0X1+S5KMJg7ftAggsUAa2c8HxAuNrq40FkEFp6ECK5sPqRMCcfOHc
 wldXHBmPBpFGEHTWQF7Ls5wyp0BkqxvLJRRAL8nlLz0x432PhXcwaguRjE/Ixxg1OJEn
 9nsiD8McotEZfKzhyoj5lSZZkDtuPIRTLVy02qnlzxyFnEJTDfQckknPcAY1qc2lKn5w lQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgmta8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 04:09:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03M47kGL150313;
        Wed, 22 Apr 2020 04:07:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30gb3t7vda-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 04:07:57 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03M47u0k000515;
        Wed, 22 Apr 2020 04:07:56 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Apr 2020 21:07:56 -0700
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <hare@suse.de>, <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <zhengbin13@huawei.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: fcoe: remove unneeded semicolon in fcoe.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200421034008.27865-1-yanaijie@huawei.com>
Date:   Wed, 22 Apr 2020 00:07:54 -0400
In-Reply-To: <20200421034008.27865-1-yanaijie@huawei.com> (Jason Yan's message
        of "Tue, 21 Apr 2020 11:40:08 +0800")
Message-ID: <yq1zhb4go2t.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=973 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220031
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> Fix the following coccicheck warning:
>
> drivers/scsi/fcoe/fcoe.c:1918:3-4: Unneeded semicolon
> drivers/scsi/fcoe/fcoe.c:1930:3-4: Unneeded semicolon

Applied to 5.8/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
