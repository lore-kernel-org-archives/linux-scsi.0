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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05327C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD08820866
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:43:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PIWd9ql9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728333AbgHaRn3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:43:29 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39548 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727963AbgHaRn1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:43:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHTf3n185226;
        Mon, 31 Aug 2020 17:43:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=tEONa2vxtDQteg9PbJKnoPWh6utRvJWO0fqZQKSw8Cc=;
 b=PIWd9ql9stqV2TtEmn2ooyvKw5iBEdf65dRsCau8DuWSjKsSSFEkEaI2NMBk5/RoSayu
 /cwXKQFUxXeJdzYFrLJv+AY7c18G3rMI9CtJMN3ff0GO1X6svLWldVI07MsZQ8hgAOY1
 uuMcO2PjVVR7mB5ENACd7/Ft/ME0PRXMsRW7rxqFHPwSNszGCiptu9yQCXvHLkJYbtSe
 gzjO7LXS1kqVPLrU1RUTCSzMsj1CNW7PDMmiFsfEkARU71lVb6JhiMlfjVsx3aXPv9fd
 SZcmS4rOzWwLqaVj/o7y1ZXCgKRvHMHc3OaGD5G5Dic3Q/24DQCQo1Zjh3Ii2VV4/Ao5 sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 337qrhene2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:43:23 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHeus2029436;
        Mon, 31 Aug 2020 17:41:23 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 3380sqbru2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:22 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07VHfM4n012396;
        Mon, 31 Aug 2020 17:41:22 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:21 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: fix spelling mistakes of "Queueing"
Date:   Mon, 31 Aug 2020 13:41:08 -0400
Message-Id: <159889566023.22322.15777127928879513502.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810080745.47314-1-colin.king@canonical.com>
References: <20200810080745.47314-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=892 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=905 bulkscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0 clxscore=1015
 suspectscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Aug 2020 09:07:45 +0100, Colin King wrote:

> There are two different spelling mistakes of "Queueing" in
> error and debug messages. Fix these.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: snic: Fix spelling mistakes of "Queueing"
      https://git.kernel.org/mkp/scsi/c/cb562b132bf8

-- 
Martin K. Petersen	Oracle Linux Engineering
