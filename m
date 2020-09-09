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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A273C43461
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB5CD20936
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Sep 2020 02:09:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qeT4I6jB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgIICJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Sep 2020 22:09:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728643AbgIICJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Sep 2020 22:09:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08921CuC087346;
        Wed, 9 Sep 2020 02:09:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=c8hGFaz7EtLlGoWOYcCyTv+fhuFWFXPf+ChVlg+HjaY=;
 b=qeT4I6jBsEGgf5PXaWnL0LxXqaLLaIKzxMhtrx7fTQkgGZGqGNTgrkVpneGmEbUt6Q9R
 zfT2f0XUar6kRwfZ2p863HvmAi9wfOvTJ/vycRrIJd9xAD4Na48kPCSPTz7g3h/eEsqH
 OmIe8VbjgExDoNrchQSaJNp8CVp4k/HzA86kO7juHtR5LmHJJCHK4Pl9UW8Yeuap8v9h
 KBHa8XTvSd4LTMcSY1YqGkC2K04ep0WuY0cSccgSWpapdpI3jmuebDs61RNzE3cZRTD4
 e6VnvmU0RUJ/s3kbmMsMXDDDnXcSU/uNW30BXuhDDfv+VtIZJo6g33djlpJQdwTVXR3j 7Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33c2mkxvmf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Sep 2020 02:09:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08926OJl185526;
        Wed, 9 Sep 2020 02:09:32 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 33cmkwwg04-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Sep 2020 02:09:31 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08929U5i022748;
        Wed, 9 Sep 2020 02:09:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 08 Sep 2020 19:09:30 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Don Brace <don.brace@microsemi.com>, POSWALD@suse.com,
        Justin.Lindley@microchip.com, hch@infradead.org,
        joseph.szczypek@hpe.com, scott.teel@microchip.com,
        Kevin.Barnett@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, jejb@linux.vnet.ibm.com,
        mahesh.rajashekhara@microchip.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: update smartpqi and hpsa
Date:   Tue,  8 Sep 2020 22:09:11 -0400
Message-Id: <159961731707.5787.5006303627304575405.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <159864510818.12656.822985017436862534.stgit@brunhilda>
References: <159864510818.12656.822985017436862534.stgit@brunhilda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 suspectscore=0
 spamscore=0 mlxlogscore=981 adultscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009090018
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9738 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015 mlxlogscore=995
 malwarescore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009090017
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 28 Aug 2020 15:05:08 -0500, Don Brace wrote:

> * change M entry e-mail to microchip
> * change L entry e-mail for storagedev to microchip

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: MAINTAINERS: Update smartpqi and hpsa
      https://git.kernel.org/mkp/scsi/c/0051a150c32f

-- 
Martin K. Petersen	Oracle Linux Engineering
