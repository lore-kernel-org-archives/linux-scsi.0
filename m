Return-Path: <SRS0=U9Ib=CS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12EB3C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEB9020936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:11:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h33fAsu7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgIICLs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:11:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIICLr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:11:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08929vgf153574;
        Wed, 9 Sep 2020 02:11:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=F4iiEKhxao2DC52tge2tJRaaUUwnf98Rba52/KeB8Pc=;
 b=h33fAsu7qKqy/I9U+RtPrgf9ESpOfC2DwmkTzfpXmLsKiuciSwMBEIiBgPblK0zVI8lw
 OBFlYdGmZYwiIiPI3aF2pMXNowZhyqpaFE0lfS8OLY3jni/h5zh6YA/VxPAzxtAUX22o
 p5aaPVo+7NFUJZYXKb6G5yYRFEi1l3eRCHr7gbQUBxmdtlp47LIeFEs7MbDAIoPCRTVG
 K3YzvQ2KS450KZ+XeLn9U+Qw+V456ILHdphxmxIsvZW1/SMcv/rZpRA38UDqUEQcbbRl
 2phDX9uowyT3xk34MQ5gYrNvV+fMj/QNUCbNANMRSG1GuQ3vCo1neGdwn9qGBLOEgYlB hQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33c3amxtvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:11:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 089252Gr095374;
        Wed, 9 Sep 2020 02:09:38 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 33cmk53esu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:38 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929aeK022852;
        Wed, 9 Sep 2020 02:09:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:36 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linuxarm@huawei.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] hisi_sas: Misc patches
Date:   Tue,  8 Sep 2020 22:09:15 -0400
Message-Id: <159961731708.5787.13618580651439543398.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
References: <1598958790-232272-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090018
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 1 Sep 2020 19:13:02 +0800, John Garry wrote:

> This series contains some minor feature updates and general tidying:
> - Some new BIST features
> - Stop modifying previously unused fields in programmable link rate reg
> - Stop accessing some SSP task fields for SMP tasks
> - General minor tidying
> 
> Thanks!
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/8] scsi: hisi_sas: Avoid accessing to SSP task for SMP I/Os
      https://git.kernel.org/mkp/scsi/c/847e83552945
[2/8] scsi: hisi_sas: Modify macro name for OOB phy linkrate
      https://git.kernel.org/mkp/scsi/c/4b3a1f1feda6
[3/8] scsi: hisi_sas: Do not modify upper fields of PROG_PHY_LINK_RATE reg
      https://git.kernel.org/mkp/scsi/c/caeddc0453b9
[4/8] scsi: hisi_sas: Make phy index variable name consistent
      https://git.kernel.org/mkp/scsi/c/ca06f2cd01d0
[5/8] scsi: hisi_sas: Add BIST support for phy FFE
      https://git.kernel.org/mkp/scsi/c/2c4d582322ff
[6/8] scsi: hisi_sas: Add BIST support for fixed code pattern
      https://git.kernel.org/mkp/scsi/c/981cc23e741a
[7/8] scsi: hisi_sas: Add missing newlines
      https://git.kernel.org/mkp/scsi/c/b601577df68a
[8/8] scsi: hisi_sas: Code style cleanup
      https://git.kernel.org/mkp/scsi/c/26f84f9bc3ba

-- 
Martin K. Petersen	Oracle Linux Engineering
