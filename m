Return-Path: <SRS0=g0vc=CJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E590C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7284820767
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aIFr3H21"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgHaRl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:41:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49038 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgHaRl1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:41:27 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHSoP1072907;
        Mon, 31 Aug 2020 17:41:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=cY1B6AskgNhwoeBBjFW8iusDxsXuCze6GsJvuYvr86w=;
 b=aIFr3H21Gt1AMx0vaiho/5ef2sJLT78nJnpfUttMV2vvMJhPG+fNW20ldOJC7RC2vzwi
 xnL4f1oZ+6qCOgbOo7YZfumtI6Ej+14JxvnYlzLg+pjSO9tWJXwUjiyXM3wNiZL00m0S
 vyEoOasXcr+Oqmh3MldiB3M7uDccpL0RoOTvQHdaWTnlo0n3drlTpefPK7TZR9d4aeWQ
 VZZCnhSaSiegsWBkBoSU5dBzJU/PHING4f6FEhwAWarrl/43B3CqW1QCJ1L8rq/CiRNM
 F1GZAyphCDj53cUnkNOrop/pvUsfiAqw0ebxbnh3c27MhMbsdvPsXvKkKsbNZHbNC0Kl AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 337eeqqmgr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:41:22 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHdbYn092033;
        Mon, 31 Aug 2020 17:41:22 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 3380xv3wu6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:21 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VHfLCF012391;
        Mon, 31 Aug 2020 17:41:21 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:20 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Colin King <colin.king@canonical.com>,
        linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: csiostor: fix fix spelling mistake "couldnt" -> "couldn't"
Date:   Mon, 31 Aug 2020 13:41:07 -0400
Message-Id: <159889566024.22322.9093103790427296260.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810090843.49553-1-colin.king@canonical.com>
References: <20200810090843.49553-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=915 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 impostorscore=0 mlxlogscore=935 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Aug 2020 10:08:43 +0100, Colin King wrote:

> There are spelling mistakes in two comments and a csio_err error
> message. Fix these.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: csiostor: Fix spelling mistake "couldnt" -> "couldn't"
      https://git.kernel.org/mkp/scsi/c/29779a22af6f

-- 
Martin K. Petersen	Oracle Linux Engineering
