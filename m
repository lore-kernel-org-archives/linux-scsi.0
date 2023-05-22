Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2709FC7EE29
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 22:47:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234979AbjEVWrI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 18:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234888AbjEVWqu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 18:46:50 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25853FA
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 15:46:45 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34MKOEmA005221;
        Mon, 22 May 2023 22:46:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=iRGZJ16F0SX9MO/bFvYBRxac+5w1FfGP49N2w43n9gQ=;
 b=pcyPSX9tguSw+krtn2waGetHlGtMHRgrW3kJZRjEobbSZiSitKG0fe8Q9yFyCfpkcblM
 7jMPlO+UMOS1rUGxEeM/RfUraeVX2DDMVzJ1JCQr5PiLtu+/SvkbeH9KQIS9wtREY3wU
 aEGmr26X8s4Hab0NCyRzmNJJ8PVQdqTz1teU02z+4w33Rs9KYk3yisYWLJYPm5AusbXR
 B3DnIsIjLGkuopBiobkXh+gmnXhdBe4JIVJzsuKY2TivF7x45LUiB6TWahpnaPCbEDHF
 1ip6NH5sg5ivSxVzWuh62KIfGPdQI44rEt7gik2mzaxVhqkdvi+4WBqZYqpEfkSE9MP+ Qg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpprtktn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:46:37 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34MLmdUF027179;
        Mon, 22 May 2023 22:46:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2ctff3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 22 May 2023 22:46:36 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34MMkPxk017332;
        Mon, 22 May 2023 22:46:36 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2ctfa8-9;
        Mon, 22 May 2023 22:46:36 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Subject: Re: [PATCH v2] scsi: MAINTAINERS: Add a libsas entry
Date:   Mon, 22 May 2023 18:46:20 -0400
Message-Id: <168479035947.1118074.13138283858310766007.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230516110131.388634-1-yanaijie@huawei.com>
References: <20230516110131.388634-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-22_16,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=970 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305220192
X-Proofpoint-GUID: 21CVPj9xR4PQCJ9pV9DucLTd6449_kA3
X-Proofpoint-ORIG-GUID: 21CVPj9xR4PQCJ9pV9DucLTd6449_kA3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 May 2023 19:01:31 +0800, Jason Yan wrote:

> John has been reviewing libsas patches for years. And I have been
> contributing to libsas for years and I am interested in reviewing and
> testing libsas patches too. So add a libsas entry and add John and me
> as reviewer.
> 
> 

Applied to 6.5/scsi-queue, thanks!

[1/1] scsi: MAINTAINERS: Add a libsas entry
      https://git.kernel.org/mkp/scsi/c/21b382460d65

-- 
Martin K. Petersen	Oracle Linux Engineering
