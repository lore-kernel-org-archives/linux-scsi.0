Return-Path: <SRS0=TWTx=Y6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94BFC5DF65
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:45:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8ADF92173B
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Nov 2019 04:45:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T3r6By/u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731274AbfKFEpL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 23:45:11 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:56498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729303AbfKFEpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 23:45:11 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i8HJ078441;
        Wed, 6 Nov 2019 04:45:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=PuZEUu0en5QF/S30iSD6oKJusYWU/qd0B3rjLgMdMVU=;
 b=T3r6By/u/59O5mUlEYLyY0PQa45lAzb8ONcRiwWKLAGdH+Iwhxv76tJrUNM8JlTJzArK
 5Xi9CQvT2leRO6cC2sIvHwLJYTohDWjWBYTtrYMSnmsnF/9tVxEvdL6Kf6SWjSGDM4j4
 7hXpuoHHSPWMKUB4FYKWAK04pelhmt5gzRIrnyNIAc4hecTpSBrWubK3a+ZImUwGeA00
 owfOPjmLOllxU7iu9exYfhS5maTOXDonuqNlks6jmpJ21Rkyyt6UMWtOMbBdY6kFrYBk
 bkpaQ5vP5MHlXDgGHNFYJjzpfYydH9eFmyk2Q+yT6VCjwLCLlebxrQw+T5f/lD8wMPZh +w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2w12eraxy4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:45:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA64i3h9175876;
        Wed, 6 Nov 2019 04:45:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2w3162nu67-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 04:45:08 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA64j7Be000924;
        Wed, 6 Nov 2019 04:45:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Nov 2019 20:45:07 -0800
To:     James Smart <jsmart2021@gmail.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 00/11] lpfc: Update lpfc to revision 12.6.0.1
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20191105005708.7399-1-jsmart2021@gmail.com>
Date:   Tue, 05 Nov 2019 23:45:05 -0500
In-Reply-To: <20191105005708.7399-1-jsmart2021@gmail.com> (James Smart's
        message of "Mon, 4 Nov 2019 16:56:57 -0800")
Message-ID: <yq17e4d3966.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=834
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060049
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9432 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=917 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060049
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


James,

> Update lpfc to revision 12.6.0.1

Applied to 5.5/scsi-queue.

Sad to see yet another driver with AMD workarounds. It really seems like
this should be addressed in the core managed IRQ code.

-- 
Martin K. Petersen	Oracle Linux Engineering
