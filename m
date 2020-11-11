Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BEBC388F7
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FD2F216C4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 02:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M6FMZw6h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKKC6q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 21:58:46 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:56030 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbgKKC6p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Nov 2020 21:58:45 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2sm5b089949;
        Wed, 11 Nov 2020 02:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=2fw+zMaJjK4Z2sWI/MIP+pVKZTJLoHqPhI/FzOnDOtw=;
 b=M6FMZw6hhjn1aMSF/g72zq+R+3/9jtspDadjRkLPDtXHnVH8E8GUEG63AuvYhdTSxAEZ
 8wfYx96F7XmzhbQ2gAbM+LGBHO4VY+qHtpNZntQPzD9yTwnxJgZAtk38Pa/x3aoLUepV
 Q5Lhdc60yFx1hZRmTYFXMMpwm/t6Wfyz2kfvwu4zlZoIAJ4vhCvWV9zEJLpzIXBEmkmf
 DX9l8VMw6wKutBOxvFRYdBrWyKNxQJOTbqJ9Q+TD2iMdF5JwFWFoM8Ve8Pmq9L0jpsuL
 7liBHDrEW700kcoWzsOes2U0JbJqK9v8DFOEYsNj1hZPuZKcBaizFYiOzLQ84tuco/ZA Lg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34nh3ay5a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 11 Nov 2020 02:58:38 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AB2tE7S057978;
        Wed, 11 Nov 2020 02:58:38 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34p55pdnkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Nov 2020 02:58:38 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AB2wb2I008155;
        Wed, 11 Nov 2020 02:58:37 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Nov 2020 18:58:37 -0800
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "trix@redhat.com" <trix@redhat.com>, jejb@linux.ibm.com,
        hare@suse.de
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: fcoe: remove unneeded semicolon
Date:   Tue, 10 Nov 2020 21:58:26 -0500
Message-Id: <160506295513.14063.7052061474895651871.b4-ty@oracle.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201101144017.2284047-1-trix@redhat.com>
References: <20201101144017.2284047-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 phishscore=0
 mlxlogscore=960 mlxscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9801 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 clxscore=1015 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=990 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011110012
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 1 Nov 2020 06:40:17 -0800, trix@redhat.com wrote:

> A semicolon is not needed after a switch statement.

Applied to 5.11/scsi-queue, thanks!

[1/1] scsi: fcoe: Remove unneeded semicolon
      https://git.kernel.org/mkp/scsi/c/00c00807a110

-- 
Martin K. Petersen	Oracle Linux Engineering
