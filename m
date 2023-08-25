Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D345C727AB
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:14:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239548AbjHYBOH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:14:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237643AbjHYBNv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:13:51 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C831BFF
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 18:13:49 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 37OJEYM3017766;
        Fri, 25 Aug 2023 01:13:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-03-30;
 bh=zMh7LYs5NEf3Ua8+9CslDsMkMfDxr7yIZB2WI08oWXY=;
 b=4Xg4W9Khrruo09KkfQZXJzll33tzEdulKG3U5B0fpPXZuXG3b0gcejcvGb2COF/yIApC
 I3BvCw3OEAXpgwlEyoPSxAahEaGXbJ9hZfm2GN80dk4mEcdW3sv1Yg+XReYDybJfWIDA
 7UeuuKnbyNqju1EOoQTy0CCUmiZk907T9llXWj/3ElXo03GpL8TknCf/jaG+VnG9G15O
 jgAF1R84ispUH3R0bOAUwIcK/GQ/+Kbhovjb7KCeRVpT/NPavetoXQUjYt951DUAMgPi
 MBOluqoLYIYtv361qPd7ch/OU0h7z9Zb+Nylg7L/t4Q2ehEQsxQMf8OaT926/nST6uS1 ng== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3sn1yvwfud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 37P03oRZ035625;
        Fri, 25 Aug 2023 01:13:41 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3sn1ywqfmu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Aug 2023 01:13:41 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 37P1DVEJ019787;
        Fri, 25 Aug 2023 01:13:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3sn1ywqf8n-14;
        Fri, 25 Aug 2023 01:13:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     john.g.garry@oracle.com, yanaijie@huawei.com, jejb@linux.ibm.com,
        Yue Haibing <yuehaibing@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next] scsi: libsas: Remove unused declarations
Date:   Thu, 24 Aug 2023 21:13:00 -0400
Message-Id: <169292577123.789945.9214401828004734428.b4-ty@oracle.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230809132249.37948-1-yuehaibing@huawei.com>
References: <20230809132249.37948-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-08-25_01,2023-08-24_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=736 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2308250009
X-Proofpoint-GUID: Lvj5k0dUXvM5piRqTKRs71xvgmc0ntJI
X-Proofpoint-ORIG-GUID: Lvj5k0dUXvM5piRqTKRs71xvgmc0ntJI
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 09 Aug 2023 21:22:49 +0800, Yue Haibing wrote:

> Commit 042ebd293b86 ("scsi: libsas: kill useless ha_event and do some cleanup")
> removed sas_hae_reset() but not its declaration.
> Commit 2908d778ab3e ("[SCSI] aic94xx: new driver") declared but never implemented
> other functions.
> 
> 

Applied to 6.6/scsi-queue, thanks!

[1/1] scsi: libsas: Remove unused declarations
      https://git.kernel.org/mkp/scsi/c/2fcd1e2b648f

-- 
Martin K. Petersen	Oracle Linux Engineering
