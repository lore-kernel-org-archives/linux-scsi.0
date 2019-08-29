Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB2CCC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A701222CEA
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:02:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cOlWzrmw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfH2WCi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:02:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46576 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbfH2WCi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:02:38 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLxH2J186486;
        Thu, 29 Aug 2019 22:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=0frvDr7eAF5VmilS4Cvw6CeNysaLIxJPebg22IrbJfg=;
 b=cOlWzrmw4N9HSshddVQ4VQnowHJJhkdyC49T4OdSLu7y1X2lfDPWUITB2sLbR/SKD2DU
 6W6yQ6XAmazsfTefXz9TpFv8DSkvBpHM0G5fszA6yAzDCPQLsGIDayxs4Ppa/U1QT+V3
 cPLF5orqNoM9+p8hpUYYIXez9P+E5yF0zQ5cLFaaIQGmoD5sGJz2QMGZ0xy5vZllsGWc
 7PpzE7Js3EsVHSE8CZNPzqHYAugH36TMNGzfMsU/H64xqlqHjK4xUFBmboX/3yU7TXHt
 vT+xc7/NqxyN0la90KrH7ut5G2s7SXBQNfB3f43kW+hQZMVXYUOWrhfN0PZIUYESj+gv 0w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2uppwwr1t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:02:31 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLxFe1178885;
        Thu, 29 Aug 2019 22:02:30 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2uphaubthb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:02:30 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TM2T0K015770;
        Thu, 29 Aug 2019 22:02:29 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:02:28 -0700
To:     zhengbin <zhengbin13@huawei.com>
Cc:     <john.garry@huawei.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH] scsi: hisi_sas: remove set but not used variable 'irq_value'
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <1566483647-121127-1-git-send-email-zhengbin13@huawei.com>
Date:   Thu, 29 Aug 2019 18:02:26 -0400
In-Reply-To: <1566483647-121127-1-git-send-email-zhengbin13@huawei.com>
        (zhengbin's message of "Thu, 22 Aug 2019 22:20:47 +0800")
Message-ID: <yq1pnknr5ot.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=663
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290219
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=740 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290219
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


zhengbin,

> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c: In function cq_interrupt_v1_hw:
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:1542:6: warning: variable irq_value set but not used [-Wunused-but-set-variable]

Applied to 5.4/scsi-queue, thanks.

-- 
Martin K. Petersen	Oracle Linux Engineering
