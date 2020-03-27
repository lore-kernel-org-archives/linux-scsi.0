Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21A32C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 03:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4F4B20714
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 03:17:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oN7BwtS8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgC0DRr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 23:17:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44490 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgC0DRr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 23:17:47 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R3CNWH090962;
        Fri, 27 Mar 2020 03:17:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=zYvuEjhYgdKftt9Or2XF4Ikl5TR2gQDFoHiGSYff5YU=;
 b=oN7BwtS8KMsjIKTiT24hdO7wXyxbT3w3NjwY9bwWuFRJ47n7KO29wtPDibn801Y4ABwJ
 rHZPuJcKIRfrn+qsEgSDml98LWLHAk+5BQtBkk1Un6/zYhNepkiudsX1NDheF9e38H2v
 UHaHbUAeGPRYuPXgwzPVUn/fKZGMIWn/u+6+q3rflsqM10knnwgwGdWnyInJSEG3iOHC
 75hOvDbVSObDGoTxOlj0pJSX9yQ8p789kGnpQ1nOUVHefaVUo1+alzxw0ACk6VbcrokX
 8EMdeSkgEeigIYczY83LxjZGF35zEUOp1DJfvU17KKlkflUktOaSggfpE7kxVi/wKIJb Mw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 300urk3svu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 03:17:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02R3CF8W192118;
        Fri, 27 Mar 2020 03:17:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3006r9jm20-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Mar 2020 03:17:44 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02R3HiYg022513;
        Fri, 27 Mar 2020 03:17:44 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 26 Mar 2020 20:17:43 -0700
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/12] lpfc: Update lpfc to revision 12.8.0.0
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200322181304.37655-1-jsmart2021@gmail.com>
Date:   Thu, 26 Mar 2020 23:17:41 -0400
In-Reply-To: <20200322181304.37655-1-jsmart2021@gmail.com> (James Smart's
        message of "Sun, 22 Mar 2020 11:12:52 -0700")
Message-ID: <yq1bloicwq2.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 spamscore=0 mlxscore=0 mlxlogscore=868 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9572 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=926 clxscore=1011 lowpriorityscore=0 mlxscore=0 phishscore=0
 bulkscore=0 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003270026
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Patch set contains mainly fixes, a change to QD default, and a few
> cleanups.

Applied to 5.7/scsi-queue. Please make sure to use the -vN argument to
git-send-email when sending updated patches. Otherwise patchwork and b4
won't handle them correctly.

-- 
Martin K. Petersen	Oracle Linux Engineering
