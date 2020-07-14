Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A20C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DDB02193E
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 04:59:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rs4VRITm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgGNE7H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 00:59:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726542AbgGNE7F (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 00:59:05 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4uwND135750;
        Tue, 14 Jul 2020 04:58:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=BW7qxCoA5rz4Ktru/2XFpXPgtF46H3pZIdoN7EUdIV4=;
 b=rs4VRITmVWmv9Csxwe4G3Q+dUZylfPm4d9GPYMRF73DW6RhFiGFHF7o1ueFmqh5QOnfP
 DlS16wy2xw26GJvk43dg8bePTEnunMhsdwzZmJMUNbCnaYtQjSbOPSBkQvxZWbsd6QWo
 TaTvU4tjO+FZJoEJ1uFiRZnqVjlzG9Ng4D0OPIR1IEB2/WwgjSXN8iA9yPgC44pGvvPp
 R0TX8+48zcZ4/ARUJM4vtxl/Swvh80Sx9GGnScBiVUnbuSdzQRlSYBngumNA15nD4eoy
 bzIQu2FuqMJurZiCMjLIE4sDsSZJQAFSTLN2hkYA7PJ5iPnGeOKZbxLvEPbyDr5LQ3dq 2w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32762natkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 14 Jul 2020 04:58:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06E4waRn098625;
        Tue, 14 Jul 2020 04:58:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 327qbwqux2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jul 2020 04:58:59 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06E4wwiZ023678;
        Tue, 14 Jul 2020 04:58:58 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jul 2020 21:58:58 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>,
        Hulk Robot <hulkci@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
Date:   Tue, 14 Jul 2020 00:58:46 -0400
Message-Id: <159470266467.11195.6170018447771951517.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200709114636.69256-1-weiyongjun1@huawei.com>
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007140037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9681 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 clxscore=1015 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 bulkscore=0 suspectscore=0 phishscore=0 adultscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007140037
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 9 Jul 2020 19:46:36 +0800, Wei Yongjun wrote:

> Gcc report warning as follows:
> 
> drivers/target/target_core_pr.c:1162:26: warning:
>  variable 'tpg' set but not used [-Wunused-but-set-variable]
>  1162 |  struct se_portal_group *tpg;
>       |                          ^~~
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: Remove unused variable 'tpg'
      https://git.kernel.org/mkp/scsi/c/dd06a40201fe

-- 
Martin K. Petersen	Oracle Linux Engineering
