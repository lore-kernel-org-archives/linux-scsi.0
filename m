Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF660C2BA2B
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:49:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9832D206B6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 01:49:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qirrjZen"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403847AbgDNBtl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 21:49:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40106 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbgDNBtk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 21:49:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1hHbc141632;
        Tue, 14 Apr 2020 01:49:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=YGoYzGvm3emavrWyA2ik1E4pbTzeRdRhNUhj8zCESeo=;
 b=qirrjZenF2GizxcTHWLcR6x6jhgJVt/x8iGxsmD/Bay0c8DXO38E6WGNCvV3mc+2BFoN
 eyCYQVw778UrjGrl75WGQVyvNIYnJOvJJoysOM52gD53ERAkI3jq8ug/sVroqZ+asER/
 12lxC8RQfKzZpXGGL1lCYgGSPgZUljwMZ+CntjykvZxDUgZnm/HN/wnBWl+oBJqRw6SC
 x4s/hGHeo2+GirfBrIBqR1aYdQ+XkzT2uoKSb0xeJXwDxQp4OQCnmRYZjnqzxnZkQHRB
 OUPZK7wF7yp9gRfZhTmIaJ38zOJrTM4xNTMOb5BzOLaMTQV6AEgefWGOKWD9QE9mkTi/ Kg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30b6hphn76-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:49:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E1fuSq106764;
        Tue, 14 Apr 2020 01:49:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 30bqpe92p8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 01:49:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03E1nU4l019931;
        Tue, 14 Apr 2020 01:49:30 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 18:49:30 -0700
To:     Manish Rangankar <mrangankar@marvell.com>
Cc:     <martin.petersen@oracle.com>, <lduncan@suse.com>,
        <cleech@redhat.com>, <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 0/6] Miscellaneous fixes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20200408064332.19377-1-mrangankar@marvell.com>
Date:   Mon, 13 Apr 2020 21:49:28 -0400
In-Reply-To: <20200408064332.19377-1-mrangankar@marvell.com> (Manish
        Rangankar's message of "Tue, 7 Apr 2020 23:43:26 -0700")
Message-ID: <yq1imi2u993.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140012
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140012
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Manish,

> Please apply the below list of patches to the scsi tree at your
> convenience.

Applied to 5.8/scsi-queue. Please write better commit descriptions next
time. I clarified a few.

Also, qedi shows several problems when compiled with -Werror C=1. Please
fix!

-- 
Martin K. Petersen	Oracle Linux Engineering
