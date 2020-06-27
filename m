Return-Path: <SRS0=t7w2=AI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB958C433DF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72F8320674
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Jun 2020 03:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ppMBKks7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725861AbgF0DJf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Jun 2020 23:09:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46150 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgF0DJf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Jun 2020 23:09:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R39WrY181096;
        Sat, 27 Jun 2020 03:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=vRRjYrM6YHTLgKFBOJ8At8bHMdUd5f9oV0CgWsrk+F0=;
 b=ppMBKks7UT4ThqBu8LRYriG0DVjP9TW0hboMHw6gjjuSiWvJIjYkQ9y8pd6ja12w7zLR
 YGHIGj71uWpiyJeB5iYuRZ2nswA1YNZ16//QQgDC72ltDOWyEhvN6T0AB+wz11BY7MmX
 4S9Y17Wd9fvM2Ue/f1743rMFf8udolzIHHecjNlXfABC3XCi6qr/f8TbG3LPdAS8CfzT
 pQRaKA35ncmmM00wKamtJzlgBDUSgms1bLk/Edd1RQuCL9lJo+WCaCQ9VnA5iinVTLM9
 mt+rCcvI7TnpUet9PsYSB0C0xAEgtpvG436e2tskNxF8ssO2CIkOh5wb10eJ9rkZXZPY wA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 31wwhr810y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 27 Jun 2020 03:09:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05R38Jlk151086;
        Sat, 27 Jun 2020 03:09:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 31wweh0w83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 27 Jun 2020 03:09:32 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 05R39VNw011712;
        Sat, 27 Jun 2020 03:09:31 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 27 Jun 2020 03:09:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Javed Hasan <jhasan@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: bnx2fc: Removal of unused variables.
Date:   Fri, 26 Jun 2020 23:09:24 -0400
Message-Id: <159322718420.11145.12589500758715701627.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622093814.3250-1-jhasan@marvell.com>
References: <20200622093814.3250-1-jhasan@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0
 malwarescore=0 adultscore=0 mlxlogscore=837 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9664 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=847 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 cotscore=-2147483648
 mlxscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006270020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Jun 2020 02:38:14 -0700, Javed Hasan wrote:

> Removed all the unused variables.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: bnx2fc: Removal of unused variables
      https://git.kernel.org/mkp/scsi/c/37d090671720

-- 
Martin K. Petersen	Oracle Linux Engineering
