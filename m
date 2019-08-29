Return-Path: <SRS0=0byZ=WZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2821AC3A59F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E87E22189D
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Aug 2019 22:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="g7uWw3Dh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728102AbfH2WwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Aug 2019 18:52:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45308 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfH2WwI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Aug 2019 18:52:08 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TMmup5040891;
        Thu, 29 Aug 2019 22:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : references : date : in-reply-to : message-id : mime-version :
 content-type; s=corp-2019-08-05;
 bh=kXb+j1+z93IKXV/d1eSC4v7+jgymYThVRIAqFXq+ZME=;
 b=g7uWw3DhnO/CxMSWHst8EV2oOdwTk1PykddlwyqNzvwfZQSjTNPuPHyDPiEyYBIRbb4c
 8Jq7Oz/o2hzbnTOP5bLq9UT0iUq3RjY5f0f/hPU2r/glKzV/zmy5W2/GPsmHMx5LaoGX
 bsi+5IbUh8LjbWj9vdbz2KAlX3w+8c+CsuOYZ9kNFwQ9X7JczFASppbXLyo6LWFNsMod
 W5I6GHh/y+542N4rnn+5SL3mGgpMokQfKISeuCNMySqtudTPXzsoYPrmCBZDtcvSTdUU
 qCRaJKH05jUG0wWaj/mhrZe8VYYIrb8byZpSEqDf8D0FyZAs6N1iCbbea5aNmFraoz54 2g== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2upqs180um-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:52:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TMn0TU030676;
        Thu, 29 Aug 2019 22:52:05 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2upc8v72bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 22:52:05 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7TMq4XO027973;
        Thu, 29 Aug 2019 22:52:04 GMT
Received: from ca-mkp.ca.oracle.com (/10.159.214.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 15:52:03 -0700
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     <martin.petersen@oracle.com>, <gbasrur@marvell.com>,
        <svernekar@marvell.com>, <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 00/14] qedf: Miscellaneous fixes.
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <20190823095244.7830-1-skashyap@marvell.com>
Date:   Thu, 29 Aug 2019 18:52:01 -0400
In-Reply-To: <20190823095244.7830-1-skashyap@marvell.com> (Saurav Kashyap's
        message of "Fri, 23 Aug 2019 02:52:30 -0700")
Message-ID: <yq1r253potq.fsf@oracle.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=595
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290227
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=672 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290227
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Saurav,

> This series have bug fixes and improve the log messages for better
> debugging.
>
> Kindly apply this series to scsi-queue at your earliest convenience.

Applied to 5.4/scsi-queue. I fixed a warning in patch #8. Please
verify. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
