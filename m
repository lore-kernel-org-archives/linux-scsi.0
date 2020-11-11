Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60642C5517A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 043C621D91
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SJne98ah"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgKKC6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:43 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49910 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgKKC6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:42 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tGMi159404;
        Wed, 11 Nov 2020 02:58:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7ZcDgeb3uXfHwzg9j9rfLyoPbsWgAZ/teiCVqIYL8i8=;
 b=SJne98ahxWT6up4kEIiOkwB6TQeJ1dsW9cqni+VHeRN3DRwsN4asCypm6SXGp/BUV2Bi
 FFo+HZpvvuqFNnim3Y9yQIZBy6ceHU3DgSeL2p7eWBj/B6E+PQeTAfjpzhgGev0nxpe4
 mfhCFaT7gETyfopEycARw72V/LNezMaFI7TRrkVUu4QE0QMWvSr2VBDRQJPfUqicz7XT
 OmWImXt9qcDjCxczSx+tVx56kKdWE9N752eySkt4MTySZEoRvRhXvYnrCEaVm096wZzh
 f2KM9dKvTBDOPIiC69GTSIqoszvf8jor301zJ+J2aguAKELSS6Qm7wsObIxkUEo5l8KL oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 34nkhkxwpv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:37 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tDA0057916;
        Wed, 11 Nov 2020 02:58:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55pdnkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:37 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB2wa9L008148;
        Wed, 11 Nov 2020 02:58:36 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:36 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "trix@redhat.com" <trix@redhat.com>, skashyap@marvell.com,
        jejb@linux.ibm.com, jhasan@marvell.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] scsi: bnx2fc: remove unneeded semicolon
Date:   Tue, 10 Nov 2020 21:58:25 -0500
Message-Id: <160506295513.14063.10787681998429655692.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101143812.2283642-1-trix@redhat.com>
References: <20201101143812.2283642-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=924 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=954 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 1 Nov 2020 06:38:12 -0800, trix@redhat.com wrote:

> A semicolon is not needed after a switch statement.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: bnx2fc: Remove unneeded semicolon
      https://git.kernel.org/mkp/scsi/c/4a9435b7b04e

-- 
Martin K. Petersen	Oracle Linux Engineering
