Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13649C47257
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:56:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD4AE20731
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 02:56:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H6msYh0c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbgEHC4o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 22:56:44 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44864 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgEHC4o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 22:56:44 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482sxeW011525;
        Fri, 8 May 2020 02:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=HlPDdRmgiCr33lpJZfIf+4xKLettL1tpIW2BHVtvg0A=;
 b=H6msYh0cWMTL2yUwQiXJ4UrUqgEDUbgasa1Q7kt8UNI+Fc55Go86OnfttW1Nie7ZneEk
 S7iuOGM8o5A8F8S/4+s/LX00xrrRtuKdTBjzOOjvTLAfEpIasoMFYkz/ZWriIw/9bZ4A
 Lq6Lp4JCRmM3BNadUZphGcA8yxUyFwMKhq5mCyYtwZB6D0Uv9lciFNQlVOQwVogQo+Ac
 Z2rQCqh4tvNMOCm1dFIkTLSycxbNi+wJ82cz4PgP0o0hFLwss/aixNUGs1CSza66AIq1
 5+iDRmCb3PYEuLmalc0iU0BMrgD9JgIoFT5uSMGEMr0OkkmD7lg+864fPX7bthQq5uhj MQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30vtewrrun-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:56:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0482ppb6138435;
        Fri, 8 May 2020 02:54:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 30vtebgpbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 May 2020 02:54:41 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0482sem7006356;
        Fri, 8 May 2020 02:54:41 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 May 2020 19:54:40 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        sreekanth.reddy@broadcom.com, Sathya.Prakash@broadcom.com
Subject: Re: [PATCH] mpt3sas: Update maintainers list.
Date:   Thu,  7 May 2020 22:54:27 -0400
Message-Id: <158890633246.6466.4856164788512428768.b4-ty@oracle.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <1588056428-29369-1-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1588056428-29369-1-git-send-email-suganath-prabu.subramani@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=793 phishscore=0 mlxscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005080022
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9614 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 mlxlogscore=853
 malwarescore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005080022
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 28 Apr 2020 02:47:08 -0400, Suganath Prabu wrote:

> Updated maintainers list for MPT DRIVERS

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Update maintainers
      https://git.kernel.org/mkp/scsi/c/4778069ccf54

-- 
Martin K. Petersen	Oracle Linux Engineering
