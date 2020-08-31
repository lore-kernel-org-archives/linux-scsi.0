Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD567C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BAA820E65
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:42:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lxcmxHIb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgHaRl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:41:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34354 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726226AbgHaRl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:41:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHU4qO143321;
        Mon, 31 Aug 2020 17:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=e7B8aXzlip+qRHgeQ+Ojjt1zl4LoC4EdvybLcudnT7c=;
 b=lxcmxHIbcbOpmnQALKY1d4LTxOnGLIGourKzUT5BHuFyakZ8eIhhF419tyg/cqDYoZ4P
 PafkgcLIwSkAm4O+MrsrqbP591zT2c7VVLqB4KmD17V8bD1M67JbO6Rnk09dMONTlzNw
 ELfJi0RSIDP68b6fwgTTi8CZphPLdKl04X5RjgwLARTkXc9iYB1G9+CSRwwnxA9XJ36M
 bFKTakxTZcRi9R+IRE3MJr6OBIHV54DBPhz0TNP6NZ7E3FN5lvCQi+U5AW8nG2GvgCBj
 6zbDs5V2kBHM03MfDFCrVS/gQKq5I8k5aR5cYVKswPcSFRxAvxSGo6/EeHCMu+8lt7g5 3w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 337eykyjg3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:41:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHf75c078325;
        Mon, 31 Aug 2020 17:41:21 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 3380kkynp5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:21 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VHfKa0018235;
        Mon, 31 Aug 2020 17:41:20 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:19 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        QLogic-Storage-Upstream@qlogic.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: fix spelling mistake "couldnt" -> "couldn't"
Date:   Mon, 31 Aug 2020 13:41:06 -0400
Message-Id: <159889566024.22322.17285471107702169784.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810085057.49039-1-colin.king@canonical.com>
References: <20200810085057.49039-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=873 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=893 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Aug 2020 09:50:57 +0100, Colin King wrote:

> There are spelling mistakes in various printk messages. Fix these.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: bnx2fc: Fix spelling mistake "couldnt" -> "couldn't"
      https://git.kernel.org/mkp/scsi/c/886a0b54f8e6

-- 
Martin K. Petersen	Oracle Linux Engineering
