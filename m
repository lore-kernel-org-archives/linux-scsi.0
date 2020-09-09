Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7094EC43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2DD6B216C4
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sH0oNYIN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbgIICJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39796 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgIICJx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089202aG146665;
        Wed, 9 Sep 2020 02:09:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=TeJUY9CAqDT2NhNH5LtP4mL8/Jil5TuZJ/5ii/ZWwyY=;
 b=sH0oNYINcHkAjlZd/vgtlIhNWh0efNCa414ncvf1svEsh1I+zWL5uDX6n+TzLlYJ8Hoe
 xgHy1zXOsAc8JFYZhB1uUk6fJPbyXU7BLuQDp7jqJyzj/O32eYVyESOhHnlX8y+BJtbw
 MSG4eLo2lgYjo2pXeFDf4WtYqcoEb89ZsFnRn7c0FumHoii5BS6AudJuxmA3IAHA6Y/I
 tC+awgKRtakntdQ2sQndt7pNNpUqO9WMwn0Zb7Wiz5Q1TrwFj6LNiSdnEEEJJrhvUrf+
 1olS1L6EVk+LEDydRNGMM2WCBFjPnBBp9/vhh8vFpLWruz41O5JmWwn21T90RJ3eUZTS Cg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33c3amxtrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:44 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08925Zqk069266;
        Wed, 9 Sep 2020 02:09:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33dacjq4ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:43 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08929f7Q007020;
        Wed, 9 Sep 2020 02:09:42 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:41 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Jason Yan <yanaijie@huawei.com>, satishkh@cisco.com,
        kartilak@cisco.com, sebaddel@cisco.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/4] scsi: fnic: build warnings clean up
Date:   Tue,  8 Sep 2020 22:09:20 -0400
Message-Id: <159961731708.5787.1672306758892214874.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200831081126.3251288-1-yanaijie@huawei.com>
References: <20200831081126.3251288-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 31 Aug 2020 16:11:22 +0800, Jason Yan wrote:

> Some build warnings cleanup.
> 
> Jason Yan (4):
>   scsi: fnic: remove set but not used 'old_vlan'
>   scsi: fnic: remove set but not used variable in
>     is_fnic_fip_flogi_reject()
>   scsi: fnic: remove set but not used 'fr_len'
>   scsi: fnic: remove set but not used 'eth_hdrs_stripped'
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/4] scsi: fnic: Remove set but not used 'old_vlan'
      https://git.kernel.org/mkp/scsi/c/c65b4f37db46
[2/4] scsi: fnic: Remove set but not used variable in is_fnic_fip_flogi_reject()
      https://git.kernel.org/mkp/scsi/c/6c53316d4898
[3/4] scsi: fnic: Remove set but not used 'fr_len'
      https://git.kernel.org/mkp/scsi/c/446034e3d419
[4/4] scsi: fnic: Remove set but not used 'eth_hdrs_stripped'
      https://git.kernel.org/mkp/scsi/c/16d7fd9079af

-- 
Martin K. Petersen	Oracle Linux Engineering
