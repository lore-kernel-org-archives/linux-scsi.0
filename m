Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBBE4C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4133206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FYRBJC/l"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgD0UVk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:21:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56864 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726654AbgD0UVj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:21:39 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKIxlL007768;
        Mon, 27 Apr 2020 20:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=Fws9Ngq7eUEIp37zcQ03w/49nH+NTWXsBsv5Ody5mmI=;
 b=FYRBJC/ltHcn81Wuis25poyTIAtcjIJkhjzr9+skbY+G0Sv5HqA1I3+a3VEv+yHKFwx9
 mwLPPFKAwQ29RBARsTnXBssVjSTDdBDX9jrO377WZQwwo7cK4bHOCXoDPYr5wNpI07gp
 BzSt2Ae71Etgu+YJOraLAu03MXdNsWe272AEwP2OmsTihep4HqKmvzVDuPFHJf2lJld2
 mlW1kyariPywXWAVrIBViM0bvrjlrTbzaT+yPelS5VPDgz+FvpU2/ZnD1kffD1Fjpmv4
 33QV03j9QsJ+lLjHxrgXeX3KdLFfquf9C01qdQ+Y1Uc77aoj4aCoV2rc3ZwIrEKwTIis 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 30nucfuw0e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKCtUu104225;
        Mon, 27 Apr 2020 20:21:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30my0agkb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:33 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLWCW006422;
        Mon, 27 Apr 2020 20:21:32 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:32 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Jason Yan <yanaijie@huawei.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sgiwd93: remove unneeded semicolon in sgiwd93.c
Date:   Mon, 27 Apr 2020 16:21:21 -0400
Message-Id: <158777063305.4076.8101834754472414433.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200421034029.28030-1-yanaijie@huawei.com>
References: <20200421034029.28030-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 adultscore=0 mlxlogscore=928 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Apr 2020 11:40:29 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/sgiwd93.c:190:2-3: Unneeded semicolon

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: sgiwd93: Remove unneeded semicolon in sgiwd93.c
      https://git.kernel.org/mkp/scsi/c/f371d5345377

-- 
Martin K. Petersen	Oracle Linux Engineering
