Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E8C0C4CECC
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24899206E2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 20:21:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a/xfJbEl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgD0UVp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 16:21:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56940 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgD0UVo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Apr 2020 16:21:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKIsS7007614;
        Mon, 27 Apr 2020 20:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=TrqYxSTGr1oSBi5jLGTcq8Sqa0dhDXB7rJzqFI/AkT4=;
 b=a/xfJbElvolJX1n8KKOc8Ab1EbaMMYX4X3wyezJYLY15MJ8/c5IuPD7FXfq+taYN9gLu
 aC9YJQW+bgmqLfY1s5HLoW9baS1ezUPBnHInQ0sDwWtgiAK42Jw9c0DKcqh76sReTLI+
 T8o38ImbBrbaxqYcl6I5bvAeo/xqEiMnAYDjugHLZRU58ZqTSIGZgvViEKUL0dS/PYaj
 lh+78HYeWzPpyX4KAJbru4rwxXNK57ni4S6sSHGxwFevfiw4BSIGOSzE1iVgcn5NVOEf
 zbaBoWmMe0okZtt3rSmPEKmSwXg7W8puc/yD7kiiXR9aVRtiUOVVZ70GkNZ8xvAy9tMu Rw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30nucfuw02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RKCc6h080826;
        Mon, 27 Apr 2020 20:21:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30mxpe1xs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 20:21:28 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03RKLPAb029809;
        Mon, 27 Apr 2020 20:21:25 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 13:21:25 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     tglx@linutronix.de, linux-kernel@vger.kernel.org,
        jejb@linux.ibm.com, anil.gurumurthy@qlogic.com,
        linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com,
        Jason Yan <yanaijie@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hulk Robot <hulkci@huawei.com>
Subject: Re: [PATCH] scsi: bfa: remove unneeded semicolon in bfa_fcs_lport_ns_sm_online()
Date:   Mon, 27 Apr 2020 16:21:14 -0400
Message-Id: <158777063303.4076.11160830259577374311.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200418070553.11262-1-yanaijie@huawei.com>
References: <20200418070553.11262-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=869 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 priorityscore=1501
 mlxlogscore=940 impostorscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270164
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 18 Apr 2020 15:05:53 +0800, Jason Yan wrote:

> Fix the following coccicheck warning:
> 
> drivers/scsi/bfa/bfa_fcs_lport.c:4361:3-4: Unneeded semicolon

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: bfa: Remove unneeded semicolon in bfa_fcs_lport_ns_sm_online()
      https://git.kernel.org/mkp/scsi/c/f166021c0f51

-- 
Martin K. Petersen	Oracle Linux Engineering
