Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE41C47404
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:33:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 409812086D
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 02:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PeaDCMpW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJJCdN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 22:33:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726465AbfJJCdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Oct 2019 22:33:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2Sd5D069241;
        Thu, 10 Oct 2019 02:33:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=GVV5N/6Mfkkv9YrvGtaZ7IsOzAep12Zvw6z9abHBjAE=;
 b=PeaDCMpW5dK+DDri45x78Jy0t4S8ynd5wWXyLd2uOOiJmFb/lMdFAZLuK/8SRBft3OBE
 pK1RkR/YCvFnW6CHAUjuRBXDhPhlQkUVCnxnGpGlTldgG7JEY/lyjUEV4Oi5CdJ8lZQE
 /IH2I6Dk1migyTW+6QcUizAC/ys3lwGMOycHEwURwP/I7HWebQPxwz5RxHESPm4WDm6M
 M4XvsvqJGBaQDJMmRGizrPHsOBtSLeLAbI2BlO15LBFuuccrt8eHyBI/QyF+NhQIceyt
 G6OwAsTV2a0psglBWO0uBnrXCW97eAI6h+m3Y6mQRnEsIz2ctU0VXT+SQ4nLDBevcqAq jw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2vektrr07b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:33:04 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9A2RuC0035251;
        Thu, 10 Oct 2019 02:33:04 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2vhrxcj881-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Oct 2019 02:33:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9A2X294011782;
        Thu, 10 Oct 2019 02:33:03 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Oct 2019 19:33:02 -0700
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <jsmart2021@gmail.com>, <james.smart@broadcom.com>,
        <dick.kennedy@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: lpfc: Make function lpfc_defer_pt2pt_acc static
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1570183477-137273-1-git-send-email-zhengbin13@huawei.com>
Date:   Wed, 09 Oct 2019 22:33:00 -0400
In-Reply-To: <1570183477-137273-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Fri, 4 Oct 2019 18:04:37 +0800")
Message-ID: <yq1eezljpnn.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=809
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9405 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=907 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910100022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> drivers/scsi/lpfc/lpfc_nportdisc.c:290:1: warning: symbol 'lpfc_defer_pt2pt_acc' was not declared. Should it be static?

Applied to 5.5/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
