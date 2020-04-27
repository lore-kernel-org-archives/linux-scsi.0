Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F23F8C4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0CD2087E
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="R2ig8pKn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgD0UXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:23:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58604 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726456AbgD0UXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:23:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKNUcK011480;
        Mon, 27 Apr 2020 20:23:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=7+T4y/ijT1JsjXYyHCQslwYNxvnO24PgRTQcxbRmtbM=;
 b=R2ig8pKnEvbHbYwuiA48U9pR1QNd7Ek4TCH61+NjCqKUR71mlLyYYL4AfhhzmJbG8Dbu
 CU6SRVpxkzy03xoJOQTDCrdIVjuxBl8kRPP8wilNokX+nQeOlNFOQJjj4TJ4DiT2XpZT
 2H+6+RjFm+DPdaqPaOUDYD1/GRgOVf41PYCVB+A3AkKoAHxFfvkzRjbVTyNJhbaFcJu2
 ryAVx0nAcb9Fc5M5eHMRyTI2GK3HtWzTd48PW2tjVFGfdpro182y0sdplzgHUcEBV+93
 XLTbkpbA4NUh6PsdXu6PBWF7Gwa7BsRcO1jEaedyBVh5TjT/idRJjYV34xIYUjvQI2cM BQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucfuw9k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:23:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKBpbO060307;
        Mon, 27 Apr 2020 20:21:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 30mxwwwfub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:29 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RKLQUE006399;
        Mon, 27 Apr 2020 20:21:26 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:26 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     tglx@linutronix.de, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, anil.gurumurthy@qlogic.com,
        linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com,
        Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: bfa: remove unneeded semicolon in bfa_fcs_rport.c
Date:   Mon, 27 Apr 2020 16:21:15 -0400
Message-Id: <158777063304.4076.619324173319114326.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200421033957.27783-1-yanaijie@huawei.com>
References: <20200421033957.27783-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=891 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=962 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270165
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 21 Apr 2020 11:39:57 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/bfa/bfa_fcs_rport.c:2452:2-3: Unneeded semicolon
> drivers/scsi/bfa/bfa_fcs_rport.c:1578:3-4: Unneeded semicolon

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: bfa: Remove unneeded semicolon in bfa_fcs_rport.c
      https://git.kernel.org/mkp/scsi/c/f71ded01cc3f

-- 
Martin K. Petersen	Oracle Linux Engineering
