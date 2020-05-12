Return-Path: <SRS0=/Ihf=62=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2178C54E8B
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8004920769
	for <linux-scsi@archiver.kernel.org>; Tue, 12 May 2020 03:29:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="atpeDeBF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgELD3C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 23:29:02 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38856 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728769AbgELD3C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 23:29:02 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3RKad105301;
        Tue, 12 May 2020 03:28:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=yjht21A+lbBhE+akid/fZHIqTGNw0vGZeU/Y9DdYpVI=;
 b=atpeDeBF8hkcxJUneGki9pZ5Bej5uq6HCZKLAGomROlQig66HJ1JtVtBHmRO1uXgF/WF
 rmxFn6tdD4MOYQ5JLvN/MejGjCe9wJTNYaoK4X4oZrj/nOXtK3Nc8my9BVoZ0lVMHwUD
 96CqHlAbVTgMBk60jKwgqbDIjqaeVieLTeEeBkpjd2Mf46//ERewS0oQez48H9O4BDGd
 I6FSXs7onKB7xHQIttIILj9Ry4I3mc4uuhIpl3Cy8GEO6MMQyNKzkBpCveQpoEyv7vd0
 nzI56c4/3hnrOcRfi27pWnbHACTWxQn75Fux/DYQIgHsWgmZopCHwOmY5NbSQDDdL8fZ +A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30x3gmghsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 03:28:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04C3NdcO074847;
        Tue, 12 May 2020 03:28:52 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30x63nxa88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 03:28:52 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04C3SqxP029053;
        Tue, 12 May 2020 03:28:52 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 May 2020 20:28:51 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     suganath-prabu.subramani@broadcom.com,
        Samuel Zou <zou_wei@huawei.com>, sathya.prakash@broadcom.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: mpt3sas: Remove unused including <linux/version.h>
Date:   Mon, 11 May 2020 23:28:36 -0400
Message-Id: <158925392374.17325.9992848339412711658.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588938573-57847-1-git-send-email-zou_wei@huawei.com>
References: <1588938573-57847-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120029
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9618 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120029
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 8 May 2020 19:49:33 +0800, Samuel Zou wrote:

> Fix the following versioncheck warning:
> 
> drivers/scsi/mpt3sas/mpt3sas_debugfs.c:16:1: unused including <linux/version.h>

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Remove unused including <linux/version.h>
      https://git.kernel.org/mkp/scsi/c/b59293b469b9

-- 
Martin K. Petersen	Oracle Linux Engineering
