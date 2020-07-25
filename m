Return-Path: <SRS0=zQak=BE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2914C433F2
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A816B2074B
	for <linux-scsi@archiver.kernel.org>; Sat, 25 Jul 2020 02:51:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hjXgE4FG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgGYCvJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jul 2020 22:51:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGYCvH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jul 2020 22:51:07 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2p4fU045232;
        Sat, 25 Jul 2020 02:51:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=E1jxlbZu5ngjHcyU+WClmjLHMGwKSJYwEZOx5LrsHJc=;
 b=hjXgE4FGmCqWk6LEf76dP9cdZDLxReG5WZSWhuboYlWkmWeQda+Gt5lw4X+Krx0dfylW
 yX7GHWIHMGwsjiLrQ+TO82up+v4ZvuVrbUISp/7vm6VvbfP/rNri4988oG1xg3JLvOq9
 rhcWKS2LKVNevw2Mi4EkcFQCuRJ87tKbpEWDgBk9ikKFfcfpGihgVtDCDVwYN4/Yyvhj
 OBEj++/wRw9ZInXqBBTmAjEqx6m5pZQFOvfX041jJaS3ZnNS1nI/nWj+tHTZcnXsKZ9R
 YvlEuDzGu/lRQvsjryr/H6RkuDEoYrV+rmwj9ZpkMI7B/Sw0DTU3eQKI7XkbY3QnyGUk Ng== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 32bs1n1ur8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 25 Jul 2020 02:51:04 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P2mWjv092386;
        Sat, 25 Jul 2020 02:51:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 32gaseas9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 25 Jul 2020 02:51:04 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06P2p22k001031;
        Sat, 25 Jul 2020 02:51:02 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 02:51:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, Yi Wang <wang.yi59@zte.com.cn>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>,
        linux-scsi@vger.kernel.org, xue.zhihong@zte.com.cn
Subject: Re: [PATCH] scsi: imm: Remove superfluous breaks
Date:   Fri, 24 Jul 2020 22:50:43 -0400
Message-Id: <159564519422.31464.1959502564009897481.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1594724367-11593-1-git-send-email-wang.yi59@zte.com.cn>
References: <1594724367-11593-1-git-send-email-wang.yi59@zte.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=805 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007250020
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=828 malwarescore=0 clxscore=1011
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007250020
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 14 Jul 2020 18:59:27 +0800, Yi Wang wrote:

> Remove superfluous breaks, as there is a "return" before them.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: imm: Remove superfluous breaks
      https://git.kernel.org/mkp/scsi/c/b54dc46cbe71

-- 
Martin K. Petersen	Oracle Linux Engineering
