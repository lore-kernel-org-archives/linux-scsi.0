Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D741FC727B0
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240200AbjHYBOK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238067AbjHYBNw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:52 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413A119BB
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:51 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEYkB027002;
        Fri, 25 Aug 2023 01:13:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=fxDGKO6/ecRI2KU3mG6zSwv7dT1wpZDt1ZCeewiYv10=;
 b=i9rl+WMfD2ZS+clntGHlvAyb2pw63reirvY1VzDkNanFDPMnfY9eUlhIBtk5FRGeXM4c
 HboZMTcn1eW+Rcobszt4m3GMVzFa9+BgXs6CdjYll/FinslCYyyr6erLuB7v6ZPkYxFb
 YnBnqxE9C8Ee5MkdoiQA6fqQ69xnLDkuR9nvXAS9KGu+Bkm2/6RYqtW5/N01LtJe+6dA
 VKBdDMKverNaNuBsv986ab7B3GKBdv+0x13H78jpDBH7u2VgIvDMiuFJyiqoNbKAgLgx
 EGxV0Ry10FI7JjdW9BLYDkHBUy6IB2YbwDU8pgyFPPCxtOI4J9+ukls9KlFthzDpyO7Q Hg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn20ddctu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:43 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P0Vhrc036087;
        Fri, 25 Aug 2023 01:13:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:42 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVEQ019787;
        Fri, 25 Aug 2023 01:13:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-17;
        Fri, 25 Aug 2023 01:13:41 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, bvanassche@acm.org,
        Yue Haibing <yuehaibing@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: Remove unused extern declarations
Date:   Thu, 24 Aug 2023 21:13:03 -0400
Message-Id: <169292577124.789945.16515054928627919093.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809142107.42756-1-yuehaibing@huawei.com>
References: <20230809142107.42756-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=655 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-GUID: x7g_c689pfEesE7UAfv0nQkXemrRxsTv
X-Proofpoint-ORIG-GUID: x7g_c689pfEesE7UAfv0nQkXemrRxsTv
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 09 Aug 2023 22:21:07 +0800, Yue Haibing wrote:

> These declarations is never implemented since the beginning of git history.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: Remove unused extern declarations
      https://git.kernel.org/mkp/scsi/c/a905b5cddcbd

-- 
Martin K. Petersen	Oracle Linux Engineering
