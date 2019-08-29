Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB6EC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:57:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6792166E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:57:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OzT9B1IR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfH2W5s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:57:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727907AbfH2W5s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:57:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TMrU1l049879;
        Thu, 29 Aug 2019 22:57:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=QQKff4RqobWQ+u8ozesrskaYCUOwLgTSmw82kzxhj4o=;
 b=OzT9B1IR44TxrRLYjDOPvBJKofPj54r1n1FQdSG0C9kc6aWY8QxFR8/k1/7aB4C2omE/
 hEp2M3eyvlVOnRYX2znBYPD1tPesOhzVSZQd6xfwSP0nh6gvBRTFX4Pr3ujjBKYELl39
 doSLyGsGNmJEj7GOCdtYnrndAJ93JP7PPvTVSwRsGOWt1UEbi+eqcCK3VbkW9TRzHZQg
 RNZlt9E/Yj788tzcG7deTeJU8NZGpbptiv7KAU+U5zOVSfQIZ2xd6pgIpNe3xmpGefpt
 nZuY5qMcQG7psdS98F4uWWCH1Xn4Esk5o8vXwKI3IU9wgnZmGVsvE7lapC3+HeyjRW5r yQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2upqsdg16v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:57:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TMmegK196285;
        Thu, 29 Aug 2019 22:55:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2upkrfj50c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:55:18 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TMtDoV013781;
        Thu, 29 Aug 2019 22:55:17 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:55:13 -0700
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <QLogic-Storage-Upstream@qlogic.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH 0/3] scsi: bnx2fc: remove some set but not used variables
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
Date:   Thu, 29 Aug 2019 18:55:11 -0400
In-Reply-To: <1566566573-49300-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Fri, 23 Aug 2019 21:22:50 +0800")
Message-ID: <yq1mufrpoog.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=939
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290228
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> zhengbin (3):
>   scsi: bnx2fc: remove set but not used variable 'fh'
>   scsi: bnx2fc: remove set but not used variables 'lport','host'
>   scsi: bnx2fc: remove set but not used variables
>     'task','port','orig_task'

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
