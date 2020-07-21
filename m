Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6F4CC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93C2F20B1F
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 03:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VZHdCFFg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728223AbgGUDo2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 23:44:28 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43748 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgGUDo2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 23:44:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3iEK8127778;
        Tue, 21 Jul 2020 03:44:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=neQ4XfqsxRwdm6YAtu4KmClGsgD9mTg2Tn9ai9iUPZE=;
 b=VZHdCFFgjFbh42TbNSVn4ExE6480VECyAGb4qLnol4rdBCJvPKg3QHlfv8TGC0VDTpr6
 yPkbWxUi8oF2sFobG/rD/a/iYhC8UDlsIElqcj+ID8CrVpZzuGX1ATxpRSrJnfC4NgH/
 gOdAfwwGPDAdfA+pr1HNxDBXdEmwFXkQuTYVeLd09hSX9Q4ImVWVoQrZKa25tXoJA6WG
 WQUVWRew61ldDpgVVZVVbKBvV5exmAFd9eCQgZg1tvgtcfFN6ueTeUL6LCHngIULUsWw
 XpM73FuyQuZe/dsVqgQxE4PgDYGm1zHBKTiSTg/AI2n1epbarylVoLI6KHF1SEgPJ9pl 3Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 32bs1mae4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 21 Jul 2020 03:44:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06L3cFIY150340;
        Tue, 21 Jul 2020 03:42:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 32dnfnqr90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 21 Jul 2020 03:42:16 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06L3gEqL015562;
        Tue, 21 Jul 2020 03:42:15 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 03:42:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, john.garry@huawei.com,
        Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: add missing newline when printing 'enable' by sysfs
Date:   Mon, 20 Jul 2020 23:42:09 -0400
Message-Id: <159530290480.22526.16753171296577291668.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1594975472-12486-1-git-send-email-wangxiongfeng2@huawei.com>
References: <1594975472-12486-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=845 suspectscore=0
 malwarescore=0 mlxscore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9688 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=862 malwarescore=0 clxscore=1011
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210024
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 17 Jul 2020 16:44:32 +0800, Xiongfeng Wang wrote:

> When I cat sysfs file 'enable' below 'sas_phy', it displays as follows.
> It's better to add a newline for easy reading.
> 
> [root@localhost ~]# cat /sys/devices/pci0000:00/0000:00:0d.0/0000:0f:00.0/host3/phy-3:2/sas_phy/phy-3:2/enable
> 1[root@localhost ~]#

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: scsi_transport_sas: Add missing newline in sysfs 'enable' attribute
      https://git.kernel.org/mkp/scsi/c/38364267251f

-- 
Martin K. Petersen	Oracle Linux Engineering
