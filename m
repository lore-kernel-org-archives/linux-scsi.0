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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7289FC433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F8C220678
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Aug 2020 17:41:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n/YxVupF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbgHaRl1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Aug 2020 13:41:27 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34362 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgHaRl0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2020 13:41:26 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHU8An143431;
        Mon, 31 Aug 2020 17:41:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=ylgEmUpxNYri/ejpa4SLv6GvDytYtRgIeXnL0d0fWOY=;
 b=n/YxVupF8i/6lapvAfefiw5gMNRn36Po4q/GeA0QXZ34xVSYd432czcw2KXwkvfT6HEp
 hDYZsNbpq/eQ3V+n6gfMUpXBDEfnBoBfp12j9qESPQixQGXXo2JkA9kH8Nm8+hiT5ALd
 cSq7bLtJ3WJzjGxkrW/4q/8MtX17mFO7I1BSHWQuuMUNrE0GXxKUfzrGMbri6JEuCmdz
 l/hoIH6LXkfM18wGJjv+H6mgACpjOxZmOjeQSM20Afre+oSJrOJjpTCJEPB1UJ81wUFu
 upyNVaif+wnJQs18zrOXF6Vjrafni7zZf4k2A5dQx38DBz1MOby+BuXeaqGBHR8b59bl Sw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 337eykyjg1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 31 Aug 2020 17:41:21 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07VHeuVY029462;
        Mon, 31 Aug 2020 17:41:20 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 3380sqbrt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Aug 2020 17:41:20 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07VHfJmE018234;
        Mon, 31 Aug 2020 17:41:19 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 31 Aug 2020 10:41:18 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Colin King <colin.king@canonical.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lpfc: fix spelling mistake "Cant" -> "Can't"
Date:   Mon, 31 Aug 2020 13:41:05 -0400
Message-Id: <159889566024.22322.10247395222535588835.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810101238.61787-1-colin.king@canonical.com>
References: <20200810101238.61787-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9730 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1011 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008310104
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 10 Aug 2020 11:12:38 +0100, Colin King wrote:

> There is a spelling mistake in an error message. Fix it.

Applied to 5.10/scsi-queue, thanks!

[1/1] scsi: lpfc: Fix spelling mistake "Cant" -> "Can't"
      https://git.kernel.org/mkp/scsi/c/a9b83986fd6e

-- 
Martin K. Petersen	Oracle Linux Engineering
