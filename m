Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD183C2D0E4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 04:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EAE924698
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 04:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZaXe+oqU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgKQEiy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 23:38:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:40476 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgKQEiy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 23:38:54 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH4YR6e031696;
        Tue, 17 Nov 2020 04:38:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=y7APG0r/bokydck1IBhchdPfzUvszS6zFkeHS2rPBow=;
 b=ZaXe+oqUx86jdo+okh2XRHHLJ78hWm9aZDZkGRhgLdFR5w2RSmcQnRmI1ixyivUx14xU
 yl90I3B0gyhGSWeQOYOiu+GuFTmi6+HigCgGG7hYP3TEEoUXlSySNiG0r29dr+h5Ks1Z
 OBjUebGpIo0wW2FfVMyfokSc4FBN/FmmnI5jXF6EmC7BczOlGA1gSmy3LUsoxKuSWtdM
 r9sHsFEB4NWwDH6qSJdes6K8mT434Mb5VnWT8NtMgY5YB71lImDqtz9iwW7mgT9lI2+x
 tdDLNapPHxm073cxYkmgN+RrTr7ToC459x8aQJTYw9EGZiF/JdqiPfubAsxN9COFtWin 6w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34t76krg8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 04:38:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AH4VYl1039885;
        Tue, 17 Nov 2020 04:38:42 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34uspsv4a3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Nov 2020 04:38:42 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AH4ceTu027733;
        Tue, 17 Nov 2020 04:38:40 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Nov 2020 20:38:39 -0800
To:     Zou Wei <zou_wei@huawei.com>
Cc:     <subbu.seetharaman@broadcom.com>, <ketan.mukadam@broadcom.com>,
        <jitendra.bhivare@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] scsi: be2iscsi: Mark beiscsi_attrs with static
 keyword
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1blfw4myg.fsf@ca-mkp.ca.oracle.com>
References: <1605339474-22329-1-git-send-email-zou_wei@huawei.com>
Date:   Mon, 16 Nov 2020 23:38:37 -0500
In-Reply-To: <1605339474-22329-1-git-send-email-zou_wei@huawei.com> (Zou Wei's
        message of "Sat, 14 Nov 2020 15:37:54 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=1 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170033
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9807 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 phishscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 clxscore=1011 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011170033
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Zou,

> Fix the following sparse warning:
>
> ./be_main.c:167:25: warning: symbol 'beiscsi_attrs' was not declared. Should it be static?

Applied to 5.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
