Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BBA2C32751
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 02:14:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0258214C6
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 02:14:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NBsi5Wly"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbfHHCOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Aug 2019 22:14:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48286 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbfHHCOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Aug 2019 22:14:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x782DmEj086881;
        Thu, 8 Aug 2019 02:14:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2018-07-02;
 bh=AhwdDa4IcV4rwdLYxZWL2L3aY1N1d0quYkiv4GPCQQ8=;
 b=NBsi5Wlyl8NDaJ4HYJeUhZz+5ARYhVBz4PZQgOSfe3q2UY/TCSHHg5S5Zc5qNGFivmKw
 mfsFBGCwRqI5pfajH+c7If27P7J93M976Z4uvPZCDQdORmat8IZjqruNaysKAbjS9Pzg
 iz/RrWJwsTCnzPVk4hhakkCQ+b3Z2cgG5w9lmdc2LIYK47YATiQCzTKzm8K/Sls6pitk
 f564DMcsgxYuH5ZUTfEK+J5mPGNpuNnyJI04WXLknJOE07zXR8bTb9hVCl2Io4BhXw4g
 GYVByZM/9npZ1sPXddir+sZ86a8eTwEW650H+DMfbn7asg1Ze2XztApQo0Zc5JiRkoFd KA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u52wrfkuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 02:14:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x782D2kN195582;
        Thu, 8 Aug 2019 02:14:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u7668asj9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Aug 2019 02:14:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x782Eg88032647;
        Thu, 8 Aug 2019 02:14:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 07 Aug 2019 19:14:42 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linuxarm@huawei.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/15] hisi_sas: Misc patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1565012892-75940-1-git-send-email-john.garry@huawei.com>
Date:   Wed, 07 Aug 2019 22:14:40 -0400
In-Reply-To: <1565012892-75940-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Mon, 5 Aug 2019 21:47:57 +0800")
Message-ID: <yq1blx0csj3.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=848
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908080021
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9342 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=916 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908080021
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20190808021440.NZXum288ZeVdCsPa18cwX_5A6kCWHfb0tlNpeOlS5f0@z>


John,

> This patchset incldues a set of misc changes for the driver.
>
> Nothing particularly stands out. Here's a quick overview:
> - minor optimisation in delivery path
> - some debugfs fixes and new minor features
> - some other very minor optimisations
> - and generally the rest are tidy-up patches

Applied to 5.4/scsi-queue. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
