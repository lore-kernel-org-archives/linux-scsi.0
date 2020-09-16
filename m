Return-Path: <SRS0=FSVS=CZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C17C43461
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D36A921D1B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Sep 2020 01:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N9RSj6O5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgIPBcd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 21:32:33 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59918 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726235AbgIPBc2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 21:32:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1UWSL168691;
        Wed, 16 Sep 2020 01:32:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : mime-version :
 content-type; s=corp-2020-01-29;
 bh=h6Npc63CvrL/i9wqyNhlTn1+9wo0BWG4NAvT8gC8wLE=;
 b=N9RSj6O5ee3qKH3/JhQpjpwUdkeA1CpMH1JD2k7xpNyscVNtZVzaZ7J0cSVFg+C8cUIb
 z7BHyhHe7EFedbY6bGM9iDIBRtusA8wtNf6hNBMAOJIClKVVuuf9R96ThVaqf2sYUTDI
 76ydzbYAPXlo4C0tL/hOa9otw9UVCcHAE7RxtJBFSkpB2pM8BCcbXaM8LJfQ37/eLzWi
 5XRsLjxsp2ktQp5RuFrsVS0bJnOU/D0kX8XODVW7GZDOBAw3P3SlwD3uHbylHVP9rjsz
 2cX9fXDyN8wxJZxOHo7BqjyIr3eK/NiszJ3Ttlx0RCx5G34xN8IgXpoRbszv7QF8bfzV iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 33j91dhx3n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Sep 2020 01:32:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08G1OvPe103184;
        Wed, 16 Sep 2020 01:30:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33h890d9md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Sep 2020 01:30:18 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08G1UGX7023862;
        Wed, 16 Sep 2020 01:30:16 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Sep 2020 01:30:15 +0000
To:     Jason Yan <yanaijie@huawei.com>
Cc:     <skashyap@marvell.com>, <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <lee.jones@linaro.org>,
        <linux-scsi@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: bnx2fc: make a bunch of symbols static in
 bnx2fc_fcoe.c
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tuvyzeyd.fsf@ca-mkp.ca.oracle.com>
References: <20200912033758.142601-1-yanaijie@huawei.com>
Date:   Tue, 15 Sep 2020 21:30:13 -0400
In-Reply-To: <20200912033758.142601-1-yanaijie@huawei.com> (Jason Yan's
        message of "Sat, 12 Sep 2020 11:37:58 +0800")
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009160006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=1 mlxlogscore=999
 clxscore=1015 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160006
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jason,

> This eliminates the following sparse warning:
>
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:53:1: warning: symbol
> 'bnx2fc_global_lock' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:111:6: warning: symbol
> 'bnx2fc_devloss_tmo' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:116:6: warning: symbol
> 'bnx2fc_max_luns' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:121:6: warning: symbol
> 'bnx2fc_queue_depth' was not declared. Should it be static?
> drivers/scsi/bnx2fc/bnx2fc_fcoe.c:126:6: warning: symbol
> 'bnx2fc_log_fka' was not declared. Should it be static?

Applied to 5.10/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
