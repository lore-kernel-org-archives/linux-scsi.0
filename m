Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEE8C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08C6D2078E
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 00:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iMXfqHG7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbgIPAT7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:19:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57850 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726912AbgIPATv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 20:19:51 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G0Evj7187107;
        Wed, 16 Sep 2020 00:19:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=1hpDoE2wgeJVQBzEyoumb0yD6A5rixQLaZ8Lr6K9zuM=;
 b=iMXfqHG710Wt27TyhK+1+srWPuB8fejjR7sGgKv7Gj7s8IYyhaRgAxSYThHCjLxGjiJY
 G3xQu9l7z0uE6inu+SQt5IeFQ+RVtMIAvJHxDjIYRhCQd6PvmqeW76tl43EMX4HAUun9
 fW3Zb94Fn4wvjBxAwO33Zefu9N/rBREND3EALD/KNuG/idbm+UrwrDLbXr4bRs0oO5Nx
 xKSbPPpORaMenfbB+BHCdieDBYKdfuaEbQIi2gmkUlAvaGD5qXgJ3b5pLXdHzmKrihSo
 TYFcWw7yH24oomxGmCVwLzV+TYwEX06+SpW0dDc1YXVm1KkBT5KB7hsJGA5bM50Qrr/s vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9m849p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 00:19:45 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G09p6Y007640;
        Wed, 16 Sep 2020 00:19:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33hm31hdxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 00:19:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08G0Jgvg016079;
        Wed, 16 Sep 2020 00:19:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 00:19:41 +0000
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <target-devel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: target: tcmu: add a missing newline when printing
 parameters
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zh5q1skp.fsf@ca-mkp.ca.oracle.com>
References: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
Date:   Tue, 15 Sep 2020 20:19:39 -0400
In-Reply-To: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
        (Xiongfeng Wang's message of "Thu, 3 Sep 2020 19:29:33 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=935
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=967
 adultscore=0 malwarescore=0 clxscore=1011 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160000
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Xiongfeng,

> When I cat module paramter 'global_max_data_area_mb' by sysfs, it
> displays as follows. It's better to add a newline for easy reading.

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
