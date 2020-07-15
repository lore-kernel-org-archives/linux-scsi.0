Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACC53C433E3
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:17:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C7B32064C
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 22:17:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LRzofQ3L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGOWQ5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 18:16:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34614 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbgGOWQ5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 18:16:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMCXVs045436;
        Wed, 15 Jul 2020 22:16:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=hajTQxL3DfoG2UFqfGqAJwoaAVaavS6nPH9dcC+/GFg=;
 b=LRzofQ3LbQ8pQPCmZHh6VugyCeTmHZEBsD9FyYraIxInlcqc6BkvTJAAVzYpel6P8lDr
 EPpaiENxpBMsvI+j0gQO2Po+hZaxDgZhoMRnHtNjAobMw7uF1cVnlNe32UaRWM1b0Yg5
 sTd8RJlQahqeWgdM7z1zKZ7HEkx5gIhvL9LZ+N+S81tR+bhjV1cBgjdwV4oLwVrX6aA8
 SQLm3mWlpuJBFz0c3bX+XeueK50AMUWlhKZbR95WeP2pBcAEzAENXNDA0YucaIc28Oz0
 L0N2gH1+5Dg/i34PFUjVpQmNqWOwMToAZSguTsDdoNjNmX14pmOggAZJCfLHuHtEIPbn xg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274ure3qv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 22:16:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FMDfrS152242;
        Wed, 15 Jul 2020 22:14:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 327q0s3mnj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 22:14:48 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06FMEjhC001059;
        Wed, 15 Jul 2020 22:14:45 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 15:14:45 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, YueHaibing <yuehaibing@huawei.com>,
        damien.lemoal@wdc.com, axboe@kernel.dk, johannes.thumshirn@wdc.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: sd_zbc: Remove unused inline functions
Date:   Wed, 15 Jul 2020 18:14:37 -0400
Message-Id: <159484884354.21107.18007748350394908907.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025523.34620-1-yuehaibing@huawei.com>
References: <20200715025523.34620-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=949 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=971 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 15 Jul 2020 10:55:23 +0800, YueHaibing wrote:

> They are never used, so can remove it.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: sd_zbc: Remove unused inline functions
      https://git.kernel.org/mkp/scsi/c/ca0800a68ac7

-- 
Martin K. Petersen	Oracle Linux Engineering
