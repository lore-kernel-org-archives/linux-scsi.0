Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8C2C3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:06:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 751AB21874
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:06:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hPN3gu3X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728004AbfH2WGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:06:46 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51574 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfH2WGp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:06:45 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM4FVq010110;
        Thu, 29 Aug 2019 22:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=3nOuSD1e70IRDUH4kWX9pjB2JgIZaQ0DUMekopfPc3Q=;
 b=hPN3gu3Xf8PUyyx4JBMIQqklKMAB8H09c9q3aFcp0cg8/W/35Z4+PkGOA1AKtB3q3ddw
 /FukN5/A5FUypZGl+HYCxfwtqhSQS2WutnP7QFugVz+90Z5tvkxIxgUGKn0Q2hmqYkAK
 JRtKeaqUgAmEcW4VvFRvMLBmSDVCahU6pbv4d5/GQ5130CbcfyWABh1jaCtClu+CY+hS
 RSxf/XxpsS8Lw9ffV/0A7jYy/1rbS1hFFHYEvtZG+0612hafrFouNZ4eWO1heZYv3mxQ
 GlLcyya22WJR/p3+lPbBQeEYfv/6DJ4lzsxNdMvO+p7DVaI8Ys9+p89LsgHrCRwfTLM6 xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2uppr9r4vc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:06:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TM49mE190358;
        Thu, 29 Aug 2019 22:05:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2uphaubw1q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:05:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TM5hOE004762;
        Thu, 29 Aug 2019 22:05:43 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 22:05:43 +0000
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <agross@kernel.org>, <avri.altman@wdc.com>,
        <pedrom.sousa@synopsys.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH v2] scsi: ufs: remove set but not used variable 'val'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1566782149-63502-1-git-send-email-zhengbin13@huawei.com>
Date:   Thu, 29 Aug 2019 18:05:40 -0400
In-Reply-To: <1566782149-63502-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Mon, 26 Aug 2019 09:15:49 +0800")
Message-ID: <yq1h85zr5jf.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=807
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290220
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=884 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290220
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/ufs/ufs-qcom.c: In function ufs_qcom_pwr_change_notify:
> drivers/scsi/ufs/ufs-qcom.c:808:6: warning: variable val set but not used [-Wunused-but-set-variable]

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
