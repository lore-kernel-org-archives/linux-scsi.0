Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 871D6C49ED7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 02:31:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E2E82171F
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 02:31:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m/wwV3yq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfIKCbr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 22:31:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57466 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfIKCbr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 22:31:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B2Supx134204;
        Wed, 11 Sep 2019 02:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=qomVzkwZbo+ACBSCTS3Y2FRLpO/90hcekpEd1aiRTWs=;
 b=m/wwV3yqPBl6xsL1b4BP7R0+ir0e3Nj/oFaqV95ebr+/5XPoB8XUSVI167kTRJiyKF8q
 K9aksf2EpDhj68OIBSaGqV57OLbyqPJ4TTaUn38fG//rraU04FYwFJRdiludC+LUbEZH
 3/oJXUelvxG9VYb4XtjBrzg5IbIT9xTI1wqKAvHSn78r33UL8ZvJnkcNripNRRb0VNzl
 JQYlBRHWexTaG/0n+KsIz43aCguR//OYV7SFh+9cnVo/DZ4tqXoxETS+CJok4s0E7Qfr
 kOdKsGTHCtdGzedkkq7MJWIsZ+qgLy8pGkym/YqXVQr8Goc4vnAoe/GtnU27+Iq+iBKI NQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uw1jy6y3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 02:31:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8B2SZ22143815;
        Wed, 11 Sep 2019 02:29:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2uxj3hwkbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Sep 2019 02:29:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x8B2TQN5001969;
        Wed, 11 Sep 2019 02:29:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Sep 2019 19:29:25 -0700
To:     John Garry <john.garry@huawei.com>
Cc:     <jejb@linux.vnet.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/13] hisi_sas: Some misc patches
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1567774537-20003-1-git-send-email-john.garry@huawei.com>
Date:   Tue, 10 Sep 2019 22:29:23 -0400
In-Reply-To: <1567774537-20003-1-git-send-email-john.garry@huawei.com> (John
        Garry's message of "Fri, 6 Sep 2019 20:55:24 +0800")
Message-ID: <yq1y2yvefb0.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=881
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909110019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9376 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=964 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909110019
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


John,

> This patchset includes support for some more minor features, a bit of
> tidying, and a few patches to make the driver a bit more robust.

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
